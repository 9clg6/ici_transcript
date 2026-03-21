import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_detail.state.freezed.dart';

/// Etat de l'ecran de detail d'une session.
@Freezed(copyWith: true)
abstract class SessionDetailState with _$SessionDetailState {
  /// Cree une instance de [SessionDetailState].
  const factory SessionDetailState({
    /// La session affichee.
    SessionEntity? session,

    /// Les segments de transcription de la session.
    required List<TranscriptSegmentEntity> segments,

    /// Indique si le titre est en cours d'edition.
    @Default(false) bool isEditing,

    /// Résumé IA de la session, null si absent.
    String? summary,
  }) = _SessionDetailState;

  /// Etat initial par defaut.
  factory SessionDetailState.initial() =>
      const SessionDetailState(segments: <TranscriptSegmentEntity>[]);
}
