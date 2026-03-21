import 'package:core_domain/domain/params/delete_session.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Supprime une session et ses segments associes.
final class DeleteSessionUseCase
    extends FutureUseCaseWithParams<void, DeleteSessionParam> {
  /// Cree une instance de [DeleteSessionUseCase].
  DeleteSessionUseCase({
    required SessionRepository sessionRepository,
    required TranscriptRepository transcriptRepository,
  }) : _sessionRepository = sessionRepository,
       _transcriptRepository = transcriptRepository;

  final SessionRepository _sessionRepository;
  final TranscriptRepository _transcriptRepository;

  @override
  Future<void> invoke(DeleteSessionParam params) async {
    await _transcriptRepository.deleteBySessionId(params.sessionId);
    await _sessionRepository.delete(params.sessionId);
  }
}
