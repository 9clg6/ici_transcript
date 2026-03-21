import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list.state.freezed.dart';

/// Etat de l'ecran de la liste des sessions (sidebar).
@Freezed(copyWith: true)
abstract class SessionListState with _$SessionListState {
  /// Cree une instance de [SessionListState].
  const factory SessionListState({
    /// Liste de toutes les sessions.
    required List<SessionEntity> sessions,

    /// Identifiant de la session actuellement selectionnee.
    String? selectedSessionId,

    /// Requete de recherche en cours.
    @Default('') String searchQuery,
  }) = _SessionListState;

  /// Etat initial par defaut.
  factory SessionListState.initial() =>
      const SessionListState(sessions: <SessionEntity>[]);
}
