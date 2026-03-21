import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_session_detail.param.freezed.dart';
part 'get_session_detail.param.g.dart';

/// Parametres pour la recuperation du detail d'une session.
@Freezed()
abstract class GetSessionDetailParam with _$GetSessionDetailParam {
  /// Cree une instance de [GetSessionDetailParam].
  const factory GetSessionDetailParam({
    /// Identifiant de la session a recuperer.
    required String sessionId,
  }) = _GetSessionDetailParam;

  /// Cree une instance depuis un JSON.
  factory GetSessionDetailParam.fromJson(Map<String, dynamic> json) =>
      _$GetSessionDetailParamFromJson(json);
}
