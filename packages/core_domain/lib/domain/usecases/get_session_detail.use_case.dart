import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/params/get_session_detail.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Resultat du detail d'une session (session + segments).
class SessionDetailResult {
  /// Cree une instance de [SessionDetailResult].
  const SessionDetailResult({required this.session, required this.segments});

  /// La session.
  final SessionEntity session;

  /// Les segments de transcription de la session.
  final List<TranscriptSegmentEntity> segments;
}

/// Recupere le detail d'une session avec ses segments.
final class GetSessionDetailUseCase
    extends
        FutureUseCaseWithParams<SessionDetailResult, GetSessionDetailParam> {
  /// Cree une instance de [GetSessionDetailUseCase].
  GetSessionDetailUseCase({
    required SessionRepository sessionRepository,
    required TranscriptRepository transcriptRepository,
  }) : _sessionRepository = sessionRepository,
       _transcriptRepository = transcriptRepository;

  final SessionRepository _sessionRepository;
  final TranscriptRepository _transcriptRepository;

  @override
  Future<SessionDetailResult> invoke(GetSessionDetailParam params) async {
    final SessionEntity? session = await _sessionRepository.getById(
      params.sessionId,
    );
    if (session == null) {
      throw Exception('Session introuvable : ${params.sessionId}');
    }
    final List<TranscriptSegmentEntity> segments = await _transcriptRepository
        .getBySessionId(params.sessionId);
    return SessionDetailResult(session: session, segments: segments);
  }
}
