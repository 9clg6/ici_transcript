import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_session.param.freezed.dart';
part 'delete_session.param.g.dart';

/// Parametres pour la suppression d'une session.
@Freezed()
abstract class DeleteSessionParam with _$DeleteSessionParam {
  /// Cree une instance de [DeleteSessionParam].
  const factory DeleteSessionParam({
    /// Identifiant de la session a supprimer.
    required String sessionId,
  }) = _DeleteSessionParam;

  /// Cree une instance depuis un JSON.
  factory DeleteSessionParam.fromJson(Map<String, dynamic> json) =>
      _$DeleteSessionParamFromJson(json);
}
