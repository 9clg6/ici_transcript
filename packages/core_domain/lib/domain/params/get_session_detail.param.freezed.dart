// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_session_detail.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetSessionDetailParam {

/// Identifiant de la session a recuperer.
 String get sessionId;
/// Create a copy of GetSessionDetailParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetSessionDetailParamCopyWith<GetSessionDetailParam> get copyWith => _$GetSessionDetailParamCopyWithImpl<GetSessionDetailParam>(this as GetSessionDetailParam, _$identity);

  /// Serializes this GetSessionDetailParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetSessionDetailParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'GetSessionDetailParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $GetSessionDetailParamCopyWith<$Res>  {
  factory $GetSessionDetailParamCopyWith(GetSessionDetailParam value, $Res Function(GetSessionDetailParam) _then) = _$GetSessionDetailParamCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$GetSessionDetailParamCopyWithImpl<$Res>
    implements $GetSessionDetailParamCopyWith<$Res> {
  _$GetSessionDetailParamCopyWithImpl(this._self, this._then);

  final GetSessionDetailParam _self;
  final $Res Function(GetSessionDetailParam) _then;

/// Create a copy of GetSessionDetailParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetSessionDetailParam].
extension GetSessionDetailParamPatterns on GetSessionDetailParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetSessionDetailParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetSessionDetailParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetSessionDetailParam value)  $default,){
final _that = this;
switch (_that) {
case _GetSessionDetailParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetSessionDetailParam value)?  $default,){
final _that = this;
switch (_that) {
case _GetSessionDetailParam() when $default != null:
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
case _GetSessionDetailParam() when $default != null:
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
case _GetSessionDetailParam():
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
case _GetSessionDetailParam() when $default != null:
return $default(_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetSessionDetailParam implements GetSessionDetailParam {
  const _GetSessionDetailParam({required this.sessionId});
  factory _GetSessionDetailParam.fromJson(Map<String, dynamic> json) => _$GetSessionDetailParamFromJson(json);

/// Identifiant de la session a recuperer.
@override final  String sessionId;

/// Create a copy of GetSessionDetailParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetSessionDetailParamCopyWith<_GetSessionDetailParam> get copyWith => __$GetSessionDetailParamCopyWithImpl<_GetSessionDetailParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetSessionDetailParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetSessionDetailParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'GetSessionDetailParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$GetSessionDetailParamCopyWith<$Res> implements $GetSessionDetailParamCopyWith<$Res> {
  factory _$GetSessionDetailParamCopyWith(_GetSessionDetailParam value, $Res Function(_GetSessionDetailParam) _then) = __$GetSessionDetailParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class __$GetSessionDetailParamCopyWithImpl<$Res>
    implements _$GetSessionDetailParamCopyWith<$Res> {
  __$GetSessionDetailParamCopyWithImpl(this._self, this._then);

  final _GetSessionDetailParam _self;
  final $Res Function(_GetSessionDetailParam) _then;

/// Create a copy of GetSessionDetailParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(_GetSessionDetailParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
