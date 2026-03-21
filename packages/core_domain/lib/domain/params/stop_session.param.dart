import 'package:freezed_annotation/freezed_annotation.dart';

part 'stop_session.param.freezed.dart';
part 'stop_session.param.g.dart';

/// Parametres pour l'arret d'une session.
@Freezed()
abstract class StopSessionParam with _$StopSessionParam {
  /// Cree une instance de [StopSessionParam].
  const factory StopSessionParam({
    /// Identifiant de la session a arreter.
    required String sessionId,
  }) = _StopSessionParam;

  /// Cree une instance depuis un JSON.
  factory StopSessionParam.fromJson(Map<String, dynamic> json) =>
      _$StopSessionParamFromJson(json);
}
