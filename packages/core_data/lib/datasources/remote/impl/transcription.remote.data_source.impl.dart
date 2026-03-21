import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:core_data/clients/websocket_client.dart';
import 'package:core_data/datasources/remote/transcription.remote.data_source.dart';
import 'package:core_data/model/audio_chunk.dart';
import 'package:core_data/model/remote/transcript_event.remote.model.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:core_domain/domain/enum/connection_state.enum.dart' as domain;
import 'package:rxdart/rxdart.dart';

/// Implementation de [TranscriptionRemoteDataSource] utilisant WebSocket.
final class TranscriptionRemoteDataSourceImpl
    implements TranscriptionRemoteDataSource {
  /// Cree une instance de [TranscriptionRemoteDataSourceImpl].
  TranscriptionRemoteDataSourceImpl({required WebSocketClient webSocketClient})
    : _webSocketClient = webSocketClient;

  final WebSocketClient _webSocketClient;
  int _sendCount = 0;

  // Buffers de mixage
  Uint8List? _pendingInput;
  Uint8List? _pendingOutput;

  // Suivi de l'activité output : si pas de chunk output depuis 500ms, passer en mode
  // pass-through (envoyer le micro directement sans attendre le bureau).
  bool _outputActive = false;
  Timer? _outputTimeoutTimer;
  static const Duration _outputTimeout = Duration(milliseconds: 500);

  final BehaviorSubject<domain.ConnectionState> _connectionStateSubject =
      BehaviorSubject<domain.ConnectionState>.seeded(
        domain.ConnectionState.disconnected,
      );

  @override
  Future<void> connect({String url = 'ws://localhost:8000/v1/realtime'}) async {
    _pendingInput = null;
    _pendingOutput = null;
    _outputActive = false;
    _outputTimeoutTimer?.cancel();
    _outputTimeoutTimer = null;
    _sendCount = 0;
    _connectionStateSubject.add(domain.ConnectionState.connecting);
    try {
      await _webSocketClient.connect(url);
      _connectionStateSubject.add(domain.ConnectionState.connected);
    } on Exception {
      _connectionStateSubject.add(domain.ConnectionState.error);
      rethrow;
    }
  }

  @override
  void sendAudio(AudioChunk chunk) {
    if (chunk.source == AudioSource.input) {
      _pendingInput = chunk.data;

      // Si output n'est pas actif, envoyer directement (pas de buffer pending)
      if (!_outputActive) {
        _sendRaw(_pendingInput!);
        _pendingInput = null;
        return;
      }
    } else {
      // Chunk output reçu : marquer output comme actif et réarmer le timeout
      _outputActive = true;
      _outputTimeoutTimer?.cancel();
      _outputTimeoutTimer = Timer(_outputTimeout, () {
        _outputActive = false;
        // Vider le pending input bloqué en attente d'output
        if (_pendingInput != null) {
          _sendRaw(_pendingInput!);
          _pendingInput = null;
        }
      });

      if (_pendingOutput != null) {
        // Nouvelle chunk output sans avoir recu d'input : micro absent,
        // envoyer directement la chunk output precedente.
        _sendRaw(_pendingOutput!);
      }
      _pendingOutput = chunk.data;
    }

    // Quand on a les deux sources, mixer et envoyer.
    if (_pendingInput != null && _pendingOutput != null) {
      _sendRaw(_mixPCM16(_pendingInput!, _pendingOutput!));
      _pendingInput = null;
      _pendingOutput = null;
    }
  }

  void _sendRaw(Uint8List data) {
    _sendCount++;
    if (_sendCount % 50 == 1) {
      final ByteData bd = ByteData.sublistView(data);
      int maxVal = 0;
      for (int i = 0; i < data.length - 1; i += 2) {
        final int v = bd.getInt16(i, Endian.little).abs();
        if (v > maxVal) maxVal = v;
      }
      // ignore: avoid_print
      print('[AUDIO] #$_sendCount: ${data.length}B max=$maxVal');
    }
    _webSocketClient.send(
      jsonEncode(<String, String>{
        'type': 'input_audio_buffer.append',
        'audio': base64Encode(data),
      }),
    );
  }

  /// Mixe deux buffers PCM Int16 en moyennant les samples.
  /// Si un des deux buffers est silencieux, retourne l'autre directement (sans diviser le volume).
  Uint8List _mixPCM16(Uint8List a, Uint8List b) {
    final int len = min(a.length, b.length) & ~1; // multiple de 2
    final bool aIsSilent = _isSilent(a, len);
    final bool bIsSilent = _isSilent(b, len);

    if (aIsSilent && !bIsSilent) return Uint8List.fromList(b.sublist(0, len));
    if (bIsSilent && !aIsSilent) return Uint8List.fromList(a.sublist(0, len));
    if (aIsSilent && bIsSilent) return Uint8List(len); // silence total

    final Uint8List out = Uint8List(len);
    final ByteData bdA = ByteData.sublistView(a);
    final ByteData bdB = ByteData.sublistView(b);
    final ByteData bdOut = ByteData.sublistView(out);
    for (int i = 0; i < len; i += 2) {
      final int s = (bdA.getInt16(i, Endian.little) + bdB.getInt16(i, Endian.little)) >> 1;
      bdOut.setInt16(i, s.clamp(-32768, 32767), Endian.little);
    }
    return out;
  }

  /// Retourne true si tous les samples sont en dessous du seuil (~0.15% du plein signal).
  bool _isSilent(Uint8List data, int len, {int threshold = 50}) {
    final ByteData bd = ByteData.sublistView(data);
    for (int i = 0; i < len; i += 2) {
      if (bd.getInt16(i, Endian.little).abs() > threshold) return false;
    }
    return true;
  }

  @override
  void sendCommit() {
    _webSocketClient.send(
      jsonEncode(<String, dynamic>{'type': 'input_audio_buffer.commit'}),
    );
  }

  @override
  Stream<TranscriptEventRemoteModel> get transcriptionStream {
    return _webSocketClient.messageStream
        .where((String message) => message.isNotEmpty)
        .map((String message) {
          final Map<String, dynamic> json =
              jsonDecode(message) as Map<String, dynamic>;
          return TranscriptEventRemoteModel.fromJson(json);
        });
  }

  @override
  Future<void> disconnect() async {
    _outputTimeoutTimer?.cancel();
    _outputTimeoutTimer = null;
    _outputActive = false;
    await _webSocketClient.disconnect();
    _connectionStateSubject.add(domain.ConnectionState.disconnected);
  }

  @override
  Stream<domain.ConnectionState> get connectionState =>
      _connectionStateSubject.stream;
}
