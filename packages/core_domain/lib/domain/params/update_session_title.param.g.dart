// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_session_title.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateSessionTitleParam _$UpdateSessionTitleParamFromJson(
  Map<String, dynamic> json,
) => _UpdateSessionTitleParam(
  sessionId: json['sessionId'] as String,
  newTitle: json['newTitle'] as String,
);

Map<String, dynamic> _$UpdateSessionTitleParamToJson(
  _UpdateSessionTitleParam instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'newTitle': instance.newTitle,
};
