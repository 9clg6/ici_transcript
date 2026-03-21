import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/params/update_session_title.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_foundation/interfaces/future.usecases.dart';

/// Met a jour le titre d'une session.
final class UpdateSessionTitleUseCase
    extends FutureUseCaseWithParams<SessionEntity, UpdateSessionTitleParam> {
  /// Cree une instance de [UpdateSessionTitleUseCase].
  UpdateSessionTitleUseCase({required SessionRepository sessionRepository})
    : _sessionRepository = sessionRepository;

  final SessionRepository _sessionRepository;

  @override
  Future<SessionEntity> invoke(UpdateSessionTitleParam params) async {
    final SessionEntity? session = await _sessionRepository.getById(
      params.sessionId,
    );
    if (session == null) {
      throw Exception('Session introuvable : ${params.sessionId}');
    }
    final SessionEntity updatedSession = session.copyWith(
      title: params.newTitle,
      updatedAt: DateTime.now(),
    );
    return _sessionRepository.update(updatedSession);
  }
}
