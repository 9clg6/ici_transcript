import 'package:core_data/model/audio_chunk.dart';
import 'package:core_data/model/remote/transcript_event.remote.model.dart';
import 'package:core_domain/domain/enum/connection_state.enum.dart' as domain;

/// Contrat de la source de donnees distante pour la transcription via WebSocket.
abstract interface class TranscriptionRemoteDataSource {
  /// Se connecte au serveur WebSocket de transcription.
  Future<void> connect({String url = 'ws://localhost:8000/v1/realtime'});

  /// Envoie un chunk audio au serveur pour transcription.
  void sendAudio(AudioChunk chunk);

  /// Stream des evenements de transcription recus du serveur.
  Stream<TranscriptEventRemoteModel> get transcriptionStream;

  /// Deconnecte du serveur WebSocket.
  Future<void> disconnect();

  /// Envoie un commit du buffer audio pour declencher la transcription.
  void sendCommit();

  /// Stream de l'etat de la connexion WebSocket.
  Stream<domain.ConnectionState> get connectionState;
}
