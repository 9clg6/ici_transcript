import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_session_title.param.freezed.dart';
part 'update_session_title.param.g.dart';

/// Parametres pour la mise a jour du titre d'une session.
@Freezed()
abstract class UpdateSessionTitleParam with _$UpdateSessionTitleParam {
  /// Cree une instance de [UpdateSessionTitleParam].
  const factory UpdateSessionTitleParam({
    /// Identifiant de la session a mettre a jour.
    required String sessionId,

    /// Nouveau titre de la session.
    required String newTitle,
  }) = _UpdateSessionTitleParam;

  /// Cree une instance depuis un JSON.
  factory UpdateSessionTitleParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateSessionTitleParamFromJson(json);
}
