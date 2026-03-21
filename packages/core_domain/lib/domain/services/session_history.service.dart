import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/params/delete_session.param.dart';
import 'package:core_domain/domain/params/get_session_detail.param.dart';
import 'package:core_domain/domain/params/update_session_title.param.dart';
import 'package:core_domain/domain/usecases/delete_session.use_case.dart';
import 'package:core_domain/domain/usecases/get_session_detail.use_case.dart';
import 'package:core_domain/domain/usecases/get_sessions.use_case.dart';
import 'package:core_domain/domain/usecases/update_session_title.use_case.dart';
import 'package:core_foundation/interfaces/results.usecases.dart';
import 'package:core_foundation/logging/logger.dart';
import 'package:rxdart/rxdart.dart';

/// Service orchestrant l'historique des sessions et les operations associees.
final class SessionHistoryService {
  /// Cree une instance de [SessionHistoryService].
  SessionHistoryService({
    required GetSessionsUseCase getSessionsUseCase,
    required GetSessionDetailUseCase getSessionDetailUseCase,
    required DeleteSessionUseCase deleteSessionUseCase,
    required UpdateSessionTitleUseCase updateSessionTitleUseCase,
  }) : _getSessionsUseCase = getSessionsUseCase,
       _getSessionDetailUseCase = getSessionDetailUseCase,
       _deleteSessionUseCase = deleteSessionUseCase,
       _updateSessionTitleUseCase = updateSessionTitleUseCase;

  final GetSessionsUseCase _getSessionsUseCase;
  final GetSessionDetailUseCase _getSessionDetailUseCase;
  final DeleteSessionUseCase _deleteSessionUseCase;
  final UpdateSessionTitleUseCase _updateSessionTitleUseCase;

  final Log _log = Log.named('SessionHistoryService');

  /// Stream reactif de la liste des sessions.
  final BehaviorSubject<List<SessionEntity>> sessionsStream =
      BehaviorSubject<List<SessionEntity>>.seeded(<SessionEntity>[]);

  /// Charge la liste des sessions.
  Future<void> loadSessions() async {
    final ResultState<List<SessionEntity>> result = await _getSessionsUseCase
        .execute();
    result.when(
      success: (List<SessionEntity> sessions) {
        sessionsStream.add(sessions);
        _log.info('${sessions.length} sessions chargees');
      },
      failure: (Exception e) {
        _log.error('Erreur chargement sessions', e);
      },
    );
  }

  /// Recupere le detail d'une session avec ses segments.
  Future<SessionDetailResult?> getSessionDetail(String sessionId) async {
    final ResultState<SessionDetailResult> result =
        await _getSessionDetailUseCase.execute(
          GetSessionDetailParam(sessionId: sessionId),
        );
    SessionDetailResult? detail;
    result.when(
      success: (SessionDetailResult data) {
        detail = data;
      },
      failure: (Exception e) {
        _log.error('Erreur chargement detail session $sessionId', e);
      },
    );
    return detail;
  }

  /// Supprime une session et recharge la liste.
  Future<void> deleteSession(String sessionId) async {
    final ResultState<void> result = await _deleteSessionUseCase.execute(
      DeleteSessionParam(sessionId: sessionId),
    );
    result.when(
      success: (_) {
        _log.info('Session supprimee : $sessionId');
        loadSessions();
      },
      failure: (Exception e) {
        _log.error('Erreur suppression session $sessionId', e);
      },
    );
  }

  /// Met a jour le titre d'une session et recharge la liste.
  Future<void> updateSessionTitle({
    required String sessionId,
    required String newTitle,
  }) async {
    final ResultState<SessionEntity> result = await _updateSessionTitleUseCase
        .execute(
          UpdateSessionTitleParam(sessionId: sessionId, newTitle: newTitle),
        );
    result.when(
      success: (SessionEntity session) {
        _log.info('Titre mis a jour : ${session.title}');
        loadSessions();
      },
      failure: (Exception e) {
        _log.error('Erreur mise a jour titre session $sessionId', e);
      },
    );
  }

  /// Libere les ressources du service.
  void dispose() {
    sessionsStream.close();
  }
}
