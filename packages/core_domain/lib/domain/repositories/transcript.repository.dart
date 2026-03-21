import 'package:core_domain/domain/entities/transcript_segment.entity.dart';

/// Contrat du repository de segments de transcription.
abstract interface class TranscriptRepository {
  /// Recupere les segments d'une session par son identifiant.
  Future<List<TranscriptSegmentEntity>> getBySessionId(String sessionId);

  /// Sauvegarde un segment de transcription.
  Future<TranscriptSegmentEntity> save(TranscriptSegmentEntity segment);

  /// Sauvegarde un lot de segments de transcription.
  Future<List<TranscriptSegmentEntity>> saveBatch(
    List<TranscriptSegmentEntity> segments,
  );

  /// Supprime tous les segments d'une session.
  Future<void> deleteBySessionId(String sessionId);
}
