import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Recupere la liste de toutes les sessions.
final class GetSessionsUseCase extends FutureUseCase<List<SessionEntity>> {
  /// Cree une instance de [GetSessionsUseCase].
  GetSessionsUseCase({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  @override
  Future<List<SessionEntity>> invoke() {
    return _sessionRepository.getAll();
  }
}
