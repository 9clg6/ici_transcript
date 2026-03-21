// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_session.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StopSessionParam {

/// Identifiant de la session a arreter.
 String get sessionId;
/// Create a copy of StopSessionParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StopSessionParamCopyWith<StopSessionParam> get copyWith => _$StopSessionParamCopyWithImpl<StopSessionParam>(this as StopSessionParam, _$identity);

  /// Serializes this StopSessionParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StopSessionParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'StopSessionParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $StopSessionParamCopyWith<$Res>  {
  factory $StopSessionParamCopyWith(StopSessionParam value, $Res Function(StopSessionParam) _then) = _$StopSessionParamCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$StopSessionParamCopyWithImpl<$Res>
    implements $StopSessionParamCopyWith<$Res> {
  _$StopSessionParamCopyWithImpl(this._self, this._then);

  final StopSessionParam _self;
  final $Res Function(StopSessionParam) _then;

/// Create a copy of StopSessionParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StopSessionParam].
extension StopSessionParamPatterns on StopSessionParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StopSessionParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StopSessionParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StopSessionParam value)  $default,){
final _that = this;
switch (_that) {
case _StopSessionParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StopSessionParam value)?  $default,){
final _that = this;
switch (_that) {
case _StopSessionParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StopSessionParam() when $default != null:
return $default(_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId)  $default,) {final _that = this;
switch (_that) {
case _StopSessionParam():
return $default(_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId)?  $default,) {final _that = this;
switch (_that) {
case _StopSessionParam() when $default != null:
return $default(_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StopSessionParam implements StopSessionParam {
  const _StopSessionParam({required this.sessionId});
  factory _StopSessionParam.fromJson(Map<String, dynamic> json) => _$StopSessionParamFromJson(json);

/// Identifiant de la session a arreter.
@override final  String sessionId;

/// Create a copy of StopSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StopSessionParamCopyWith<_StopSessionParam> get copyWith => __$StopSessionParamCopyWithImpl<_StopSessionParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StopSessionParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopSessionParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'StopSessionParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$StopSessionParamCopyWith<$Res> implements $StopSessionParamCopyWith<$Res> {
  factory _$StopSessionParamCopyWith(_StopSessionParam value, $Res Function(_StopSessionParam) _then) = __$StopSessionParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class __$StopSessionParamCopyWithImpl<$Res>
    implements _$StopSessionParamCopyWith<$Res> {
  __$StopSessionParamCopyWithImpl(this._self, this._then);

  final _StopSessionParam _self;
  final $Res Function(_StopSessionParam) _then;

/// Create a copy of StopSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(_StopSessionParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
