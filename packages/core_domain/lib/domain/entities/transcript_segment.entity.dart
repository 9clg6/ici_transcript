import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcript_segment.entity.freezed.dart';

/// Entite representant un segment de transcription.
@freezed
abstract class TranscriptSegmentEntity with _$TranscriptSegmentEntity {
  /// Cree une instance de [TranscriptSegmentEntity].
  const factory TranscriptSegmentEntity({
    /// Identifiant unique du segment.
    required String id,

    /// Identifiant de la session parente.
    required String sessionId,

    /// Source audio du segment (micro ou systeme).
    required AudioSource source,

    /// Texte transcrit.
    required String text,

    /// Offset en millisecondes depuis le debut de la session.
    required int timestampMs,

    /// Date de creation du segment.
    required DateTime createdAt,
  }) = _TranscriptSegmentEntity;
}
