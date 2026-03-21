import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/params/stop_session.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Arrete une session de transcription en cours.
final class StopSessionUseCase
    extends FutureUseCaseWithParams<SessionEntity, StopSessionParam> {
  /// Cree une instance de [StopSessionUseCase].
  StopSessionUseCase({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  @override
  Future<SessionEntity> invoke(StopSessionParam params) async {
    final SessionEntity? session = await _sessionRepository.getById(
      params.sessionId,
    );
    if (session == null) {
      throw Exception('Session introuvable : ${params.sessionId}');
    }
    final DateTime now = DateTime.now();
    final int durationSeconds = now.difference(session.createdAt).inSeconds;
    final SessionEntity updatedSession = session.copyWith(
      status: SessionStatus.completed,
      updatedAt: now,
      durationSeconds: durationSeconds,
    );
    return _sessionRepository.update(updatedSession);
  }
}
