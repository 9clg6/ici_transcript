import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Sauvegarde un segment de transcription.
final class SaveTranscriptSegmentUseCase
    extends
        FutureUseCaseWithParams<
          TranscriptSegmentEntity,
          TranscriptSegmentEntity
        > {
  /// Cree une instance de [SaveTranscriptSegmentUseCase].
  SaveTranscriptSegmentUseCase({
    required TranscriptRepository transcriptRepository,
  }) : _transcriptRepository = transcriptRepository;

  final TranscriptRepository _transcriptRepository;

  @override
  Future<TranscriptSegmentEntity> invoke(TranscriptSegmentEntity params) {
    return _transcriptRepository.save(params);
  }
}
