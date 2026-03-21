import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Demarre une nouvelle session de transcription.
final class StartSessionUseCase extends FutureUseCase<SessionEntity> {
  /// Cree une instance de [StartSessionUseCase].
  StartSessionUseCase({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  @override
  Future<SessionEntity> invoke() {
    final DateTime now = DateTime.now();
    final SessionEntity session = SessionEntity(
      id: now.millisecondsSinceEpoch.toString(),
      title:
          'Session ${now.toIso8601String().substring(0, 16).replaceAll('T', ' ')}',
      createdAt: now,
      updatedAt: now,
      status: SessionStatus.active,
    );
    return _sessionRepository.create(session);
  }
}
