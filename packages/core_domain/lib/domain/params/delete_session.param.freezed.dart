// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_session.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteSessionParam {

/// Identifiant de la session a supprimer.
 String get sessionId;
/// Create a copy of DeleteSessionParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteSessionParamCopyWith<DeleteSessionParam> get copyWith => _$DeleteSessionParamCopyWithImpl<DeleteSessionParam>(this as DeleteSessionParam, _$identity);

  /// Serializes this DeleteSessionParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteSessionParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'DeleteSessionParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $DeleteSessionParamCopyWith<$Res>  {
  factory $DeleteSessionParamCopyWith(DeleteSessionParam value, $Res Function(DeleteSessionParam) _then) = _$DeleteSessionParamCopyWithImpl;
@useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class _$DeleteSessionParamCopyWithImpl<$Res>
    implements $DeleteSessionParamCopyWith<$Res> {
  _$DeleteSessionParamCopyWithImpl(this._self, this._then);

  final DeleteSessionParam _self;
  final $Res Function(DeleteSessionParam) _then;

/// Create a copy of DeleteSessionParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DeleteSessionParam].
extension DeleteSessionParamPatterns on DeleteSessionParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeleteSessionParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeleteSessionParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeleteSessionParam value)  $default,){
final _that = this;
switch (_that) {
case _DeleteSessionParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeleteSessionParam value)?  $default,){
final _that = this;
switch (_that) {
case _DeleteSessionParam() when $default != null:
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
case _DeleteSessionParam() when $default != null:
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
case _DeleteSessionParam():
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
case _DeleteSessionParam() when $default != null:
return $default(_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeleteSessionParam implements DeleteSessionParam {
  const _DeleteSessionParam({required this.sessionId});
  factory _DeleteSessionParam.fromJson(Map<String, dynamic> json) => _$DeleteSessionParamFromJson(json);

/// Identifiant de la session a supprimer.
@override final  String sessionId;

/// Create a copy of DeleteSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteSessionParamCopyWith<_DeleteSessionParam> get copyWith => __$DeleteSessionParamCopyWithImpl<_DeleteSessionParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteSessionParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeleteSessionParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId);

@override
String toString() {
  return 'DeleteSessionParam(sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$DeleteSessionParamCopyWith<$Res> implements $DeleteSessionParamCopyWith<$Res> {
  factory _$DeleteSessionParamCopyWith(_DeleteSessionParam value, $Res Function(_DeleteSessionParam) _then) = __$DeleteSessionParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId
});




}
/// @nodoc
class __$DeleteSessionParamCopyWithImpl<$Res>
    implements _$DeleteSessionParamCopyWith<$Res> {
  __$DeleteSessionParamCopyWithImpl(this._self, this._then);

  final _DeleteSessionParam _self;
  final $Res Function(_DeleteSessionParam) _then;

/// Create a copy of DeleteSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,}) {
  return _then(_DeleteSessionParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
