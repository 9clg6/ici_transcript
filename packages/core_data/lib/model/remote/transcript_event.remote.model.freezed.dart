// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_event.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptEventRemoteModel {

/// Type d'evenement (ex: 'response.audio_transcript.delta').
 String get type;/// Delta de transcription incrementale.
 String? get delta;/// Transcription complete du segment (champ `text` de voxmlx-serve).
 String? get text;
/// Create a copy of TranscriptEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptEventRemoteModelCopyWith<TranscriptEventRemoteModel> get copyWith => _$TranscriptEventRemoteModelCopyWithImpl<TranscriptEventRemoteModel>(this as TranscriptEventRemoteModel, _$identity);

  /// Serializes this TranscriptEventRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptEventRemoteModel&&(identical(other.type, type) || other.type == type)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,delta,text);

@override
String toString() {
  return 'TranscriptEventRemoteModel(type: $type, delta: $delta, text: $text)';
}


}

/// @nodoc
abstract mixin class $TranscriptEventRemoteModelCopyWith<$Res>  {
  factory $TranscriptEventRemoteModelCopyWith(TranscriptEventRemoteModel value, $Res Function(TranscriptEventRemoteModel) _then) = _$TranscriptEventRemoteModelCopyWithImpl;
@useResult
$Res call({
 String type, String? delta, String? text
});




}
/// @nodoc
class _$TranscriptEventRemoteModelCopyWithImpl<$Res>
    implements $TranscriptEventRemoteModelCopyWith<$Res> {
  _$TranscriptEventRemoteModelCopyWithImpl(this._self, this._then);

  final TranscriptEventRemoteModel _self;
  final $Res Function(TranscriptEventRemoteModel) _then;

/// Create a copy of TranscriptEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? delta = freezed,Object? text = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptEventRemoteModel].
extension TranscriptEventRemoteModelPatterns on TranscriptEventRemoteModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptEventRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptEventRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptEventRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? delta,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel() when $default != null:
return $default(_that.type,_that.delta,_that.text);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? delta,  String? text)  $default,) {final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel():
return $default(_that.type,_that.delta,_that.text);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? delta,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptEventRemoteModel() when $default != null:
return $default(_that.type,_that.delta,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranscriptEventRemoteModel implements TranscriptEventRemoteModel {
  const _TranscriptEventRemoteModel({required this.type, this.delta, this.text});
  factory _TranscriptEventRemoteModel.fromJson(Map<String, dynamic> json) => _$TranscriptEventRemoteModelFromJson(json);

/// Type d'evenement (ex: 'response.audio_transcript.delta').
@override final  String type;
/// Delta de transcription incrementale.
@override final  String? delta;
/// Transcription complete du segment (champ `text` de voxmlx-serve).
@override final  String? text;

/// Create a copy of TranscriptEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptEventRemoteModelCopyWith<_TranscriptEventRemoteModel> get copyWith => __$TranscriptEventRemoteModelCopyWithImpl<_TranscriptEventRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptEventRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptEventRemoteModel&&(identical(other.type, type) || other.type == type)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,delta,text);

@override
String toString() {
  return 'TranscriptEventRemoteModel(type: $type, delta: $delta, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TranscriptEventRemoteModelCopyWith<$Res> implements $TranscriptEventRemoteModelCopyWith<$Res> {
  factory _$TranscriptEventRemoteModelCopyWith(_TranscriptEventRemoteModel value, $Res Function(_TranscriptEventRemoteModel) _then) = __$TranscriptEventRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String type, String? delta, String? text
});




}
/// @nodoc
class __$TranscriptEventRemoteModelCopyWithImpl<$Res>
    implements _$TranscriptEventRemoteModelCopyWith<$Res> {
  __$TranscriptEventRemoteModelCopyWithImpl(this._self, this._then);

  final _TranscriptEventRemoteModel _self;
  final $Res Function(_TranscriptEventRemoteModel) _then;

/// Create a copy of TranscriptEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? delta = freezed,Object? text = freezed,}) {
  return _then(_TranscriptEventRemoteModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
