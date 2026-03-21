import 'dart:async';

import 'package:flutter/services.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/server_state.enum.dart';
import 'package:core_foundation/logging/logger.dart';
import 'package:ici_transcript/application/services/live_transcription.service.dart';
import 'package:ici_transcript/core/providers/services/live_transcription.service.provider.dart';
import 'package:ici_transcript/core/providers/services/process_manager.service.provider.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.view_model.dart';
import 'package:ici_transcript/features/transcription/presentation/screens/live/live_transcription.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'live_transcription.view_model.g.dart';

/// ViewModel de l'ecran de transcription en direct.
@Riverpod(keepAlive: true)
class LiveTranscriptionViewModel extends _$LiveTranscriptionViewModel {
  final Log _log = Log.named('LiveTranscriptionViewModel');
  Timer? _durationTimer;
  LiveTranscriptionService? _liveService;
  bool _subscribed = false;

  @override
  LiveTranscriptionState build() {
    _liveService = ref.watch(liveTranscriptionServiceProvider);

    // Ecouter les streams UNE seule fois
    if (!_subscribed) {
      _subscribed = true;
      _listenToStreams();
    }
    // Re-vérifier les permissions à chaque rebuild (évite que initial() écrase
    // les valeurs connues si Riverpod invalide le provider)
    Future<void>.microtask(() => recheckPermissions());

    ref.onDispose(() {
      _durationTimer?.cancel();
    });

    return LiveTranscriptionState.initial();
  }

  void _listenToStreams() {
    // Ecoute l'etat du serveur
    ref.watch(processManagerServiceProvider).stateStream.listen((
      ServerState serverState,
    ) {
      state = state.copyWith(serverState: serverState);
        });

    // Ecoute les segments de la transcription
    _liveService?.segmentsStream.listen((
      List<TranscriptSegmentEntity> segments,
    ) {
      _log.debug('Segments mis a jour: ${segments.length}');
      state = state.copyWith(segments: segments);
        });

    // Ecoute l'etat d'enregistrement
    _liveService?.isRecordingStream.listen((bool isRecording) {
      _log.debug('isRecording: $isRecording');
      state = state.copyWith(isRecording: isRecording);
      if (!isRecording) {
        _durationTimer?.cancel();
        _durationTimer = null;
      }
        });
  }

  /// Demarre une nouvelle session de transcription.
  Future<void> startSession() async {
    _log.info('startSession() appele');

    // Mettre a jour l'UI immediatement
    state = state.copyWith(
      isRecording: true,
      isPaused: false,
      segments: <TranscriptSegmentEntity>[],
      duration: Duration.zero,
    );

    // Demarrer le timer
    _startDurationTimer();

    try {
      final String? micId =
          ref.read(settingsViewModelProvider).selectedMicId;
      final bool systemAudio =
          ref.read(settingsViewModelProvider).systemAudioEnabled;
      await _liveService?.startTranscription(
        inputDeviceId: micId,
        serverCommand: 'uvx',
        serverArgs: const <String>[
          '--from',
          'git+https://github.com/T0mSIlver/voxmlx.git[server]',
          'voxmlx-serve',
          '--model',
          'T0mSIlver/Voxtral-Mini-4B-Realtime-2602-MLX-4bit',
        ],
        outputEnabled: systemAudio,
      );
      _log.info('startTranscription OK');
    } catch (e) {
      _log.error('ERREUR startTranscription: $e');
      if (e is PlatformException && e.code == 'MIC_PERMISSION_DENIED') {
        state = state.copyWith(isRecording: false, micPermission: 'denied');
      } else {
        state = state.copyWith(
          isRecording: false,
          serverState: ServerState.error,
        );
      }
      _durationTimer?.cancel();
      // Nettoyage propre : arrête audio, WebSocket et session côté Dart
      // (évite le double-stop Swift + Dart)
      await _liveService?.stopTranscription();
    }
  }

  /// Arrete la session.
  Future<void> stopSession() async {
    _durationTimer?.cancel();
    _durationTimer = null;
    await _liveService?.stopTranscription();
    state = state.copyWith(isRecording: false, isPaused: false);
  }

  /// Met en pause.
  void pauseSession() {
    _durationTimer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  /// Reprend.
  void resumeSession() {
    state = state.copyWith(isPaused: false);
    _startDurationTimer();
  }

  /// Vérifie les permissions et met à jour le state.
  Future<void> recheckPermissions() async {
    try {
      final Map<String, String> perms =
          await _liveService?.checkPermissions() ?? <String, String>{};
      state = state.copyWith(
        micPermission: perms['mic'] ?? 'unknown',
        screenRecordingPermission: perms['screenRecording'] ?? 'unknown',
      );
    } catch (_) {
      // Silencieux — ne pas crasher si la vérification échoue
    }
  }

  /// Ouvre les Réglages Système pour la permission microphone.
  Future<void> openMicSettings() async {
    await _liveService?.openSystemSettings('microphone');
  }

  /// Ouvre les Réglages Système pour la permission Screen Recording.
  Future<void> openScreenRecordingSettings() async {
    await _liveService?.openSystemSettings('screenRecording');
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!state.isPaused) {
        state = state.copyWith(
          duration: state.duration + const Duration(seconds: 1),
        );
      }
    });
  }
}
