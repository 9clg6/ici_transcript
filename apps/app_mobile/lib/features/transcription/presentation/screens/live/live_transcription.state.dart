import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/server_state.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_transcription.state.freezed.dart';

/// Etat de l'ecran de transcription en direct.
@Freezed(copyWith: true)
abstract class LiveTranscriptionState with _$LiveTranscriptionState {
  /// Cree une instance de [LiveTranscriptionState].
  const factory LiveTranscriptionState({
    /// Liste des segments de transcription de la session courante.
    required List<TranscriptSegmentEntity> segments,

    /// Indique si un enregistrement est en cours.
    @Default(false) bool isRecording,

    /// Indique si l'enregistrement est en pause.
    @Default(false) bool isPaused,

    /// Duree actuelle de la session.
    @Default(Duration.zero) Duration duration,

    /// Etat du serveur de transcription.
    @Default(ServerState.stopped) ServerState serverState,

    /// Titre de la session en cours.
    String? sessionTitle,

    /// Statut de la permission microphone.
    /// Valeurs : "authorized", "denied", "notDetermined", "restricted", "unknown".
    @Default('unknown') String micPermission,

    /// Statut de la permission Screen Recording.
    /// Valeurs : "authorized", "denied", "notDetermined", "unknown".
    @Default('unknown') String screenRecordingPermission,

    /// Indique si l'option résumé IA est activée.
    @Default(false) bool isSummaryEnabled,

    /// Résumé IA de la session (null si pas encore généré).
    String? summary,

    /// Indique si le résumé est en cours de génération.
    @Default(false) bool isSummaryLoading,
  }) = _LiveTranscriptionState;

  /// Etat initial par defaut.
  factory LiveTranscriptionState.initial() =>
      const LiveTranscriptionState(segments: <TranscriptSegmentEntity>[]);
}
