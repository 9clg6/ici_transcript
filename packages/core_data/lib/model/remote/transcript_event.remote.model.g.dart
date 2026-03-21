// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_event.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranscriptEventRemoteModel _$TranscriptEventRemoteModelFromJson(
  Map<String, dynamic> json,
) => _TranscriptEventRemoteModel(
  type: json['type'] as String,
  delta: json['delta'] as String?,
  text: json['text'] as String?,
);

Map<String, dynamic> _$TranscriptEventRemoteModelToJson(
  _TranscriptEventRemoteModel instance,
) => <String, dynamic>{
  'type': instance.type,
  'delta': instance.delta,
  'text': instance.text,
};
