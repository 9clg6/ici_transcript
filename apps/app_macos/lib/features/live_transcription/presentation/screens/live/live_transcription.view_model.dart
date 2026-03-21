import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/server_state.enum.dart';
import 'package:core_foundation/logging/logger.dart';
import 'package:ici_transcript/application/services/live_transcription.service.dart';
import 'package:ici_transcript/core/providers/services/live_transcription.service.provider.dart';
import 'package:ici_transcript/core/providers/services/process_manager.service.provider.dart';
import 'package:ici_transcript/application/services/ollama.service.dart';
import 'package:ici_transcript/core/providers/services/ollama.service.provider.dart';
import 'package:ici_transcript/core/providers/services/session_history.service.provider.dart';
import 'package:ici_transcript/core/providers/services/summary.service.provider.dart';
import 'package:ici_transcript/features/settings/presentation/screens/settings/settings.view_model.dart';
import 'package:ici_transcript/features/live_transcription/presentation/screens/live/live_transcription.state.dart';
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

    state = state.copyWith(
      isRecording: true,
      isPaused: false,
      segments: <TranscriptSegmentEntity>[],
      duration: Duration.zero,
      summary: null,
    );

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
      await _liveService?.stopTranscription();
    }
  }

  /// Arrete la session, sauvegarde la transcription et génère un résumé si activé.
  Future<void> stopSession() async {
    _durationTimer?.cancel();
    _durationTimer = null;

    // Capturer l'ID de session avant d'arrêter
    final String? sessionId =
        _liveService?.currentSessionStream.value?.id;

    await _liveService?.stopTranscription();

    final List<TranscriptSegmentEntity> segments = state.segments;
    // Vider les segments immédiatement — chaque session commence vierge
    state = state.copyWith(
      isRecording: false,
      isPaused: false,
      segments: <TranscriptSegmentEntity>[],
      duration: Duration.zero,
    );

    // Sauvegarder la transcription en local
    await _saveTranscriptToFile(segments);

    // Rafraichir la liste des sessions dans la sidebar
    await ref.read(sessionHistoryServiceProvider).loadSessions();

    // Générer le résumé si l'option est activée
    if (state.isSummaryEnabled && segments.isNotEmpty) {
      await _generateSummary(segments, sessionId: sessionId);
    }
  }

  /// Active ou désactive l'option résumé IA.
  void toggleSummary() {
    state = state.copyWith(isSummaryEnabled: !state.isSummaryEnabled);
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

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

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

  /// Sauvegarde la transcription dans un fichier texte local.
  Future<void> _saveTranscriptToFile(
    List<TranscriptSegmentEntity> segments,
  ) async {
    if (segments.isEmpty) return;
    try {
      final String home = Platform.environment['HOME'] ?? '';
      final Directory dir = Directory(
        '$home/Library/Application Support/IciTranscript/transcripts',
      );
      await dir.create(recursive: true);

      final String timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-');
      final File file = File('${dir.path}/transcript_$timestamp.txt');

      final StringBuffer buffer = StringBuffer();
      for (final TranscriptSegmentEntity segment in segments) {
        final Duration ts = Duration(milliseconds: segment.timestampMs);
        final String time =
            '${ts.inMinutes.toString().padLeft(2, '0')}:${(ts.inSeconds % 60).toString().padLeft(2, '0')}';
        buffer.writeln('[$time] ${segment.text}');
      }

      await file.writeAsString(buffer.toString());
      _log.info('Transcription sauvegardee: ${file.path}');
    } catch (e) {
      _log.error('Erreur sauvegarde transcription: $e');
    }
  }

  /// Génère un résumé via Ollama (modèle local Mistral) et le sauvegarde.
  Future<void> _generateSummary(
    List<TranscriptSegmentEntity> segments, {
    String? sessionId,
  }) async {
    state = state.copyWith(isSummaryLoading: true);

    // S'assurer qu'Ollama est prêt (téléchargement binaire + modèle si besoin)
    try {
      await ref.read(ollamaServiceProvider).ensureReady(
        onProgress: (OllamaSetupStage stage, double progress) {
          state = state.copyWith(
            ollamaSetupStage: stage,
            ollamaSetupProgress: progress,
          );
        },
      );
      state = state.copyWith(
        ollamaSetupStage: OllamaSetupStage.idle,
        ollamaSetupProgress: 0,
      );
    } catch (e) {
      _log.error('Ollama setup échoué: $e');
      state = state.copyWith(
        isSummaryLoading: false,
        ollamaSetupStage: OllamaSetupStage.error,
        ollamaSetupError: e.toString(),
        summary: 'Erreur Ollama : $e',
      );
      return;
    }

    try {
      final String transcript = segments
          .map((TranscriptSegmentEntity s) => s.text)
          .join('\n');

      // API native Ollama /api/chat (compatible toutes versions)
      final Dio dio = Dio();
      final Response<Map<String, dynamic>> response = await dio.post<
          Map<String, dynamic>>(
        'http://localhost:11434/api/chat',
        data: <String, dynamic>{
          'model': 'mistral',
          'stream': false,
          'messages': <Map<String, dynamic>>[
            <String, dynamic>{
              'role': 'user',
              'content':
                  'Résume en français de manière concise cette transcription de conversation :\n\n$transcript',
            },
          ],
        },
        options: Options(
          headers: <String, String>{
            'content-type': 'application/json',
          },
        ),
      );

      // Réponse native : { "message": { "content": "..." } }
      final Map<String, dynamic> message =
          response.data?['message'] as Map<String, dynamic>? ??
              <String, dynamic>{};
      final String summary = message['content'] as String? ?? '';

      state = state.copyWith(isSummaryLoading: false, summary: summary);
      _log.info('Résumé généré via Ollama');

      // Sauvegarder le résumé en base de données
      if (sessionId != null && summary.isNotEmpty) {
        await ref.read(summaryServiceProvider).saveSummary(
          sessionId: sessionId,
          content: summary,
        );
        _log.info('Résumé sauvegardé pour session $sessionId');
      }
    } catch (e) {
      _log.error('Erreur génération résumé Ollama: $e');
      state = state.copyWith(
        isSummaryLoading: false,
        summary:
            'Ollama non disponible. Lancez : ollama run mistral',
      );
    }
  }
}
