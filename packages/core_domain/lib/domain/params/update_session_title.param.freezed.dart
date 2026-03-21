// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_session_title.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateSessionTitleParam {

/// Identifiant de la session a mettre a jour.
 String get sessionId;/// Nouveau titre de la session.
 String get newTitle;
/// Create a copy of UpdateSessionTitleParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSessionTitleParamCopyWith<UpdateSessionTitleParam> get copyWith => _$UpdateSessionTitleParamCopyWithImpl<UpdateSessionTitleParam>(this as UpdateSessionTitleParam, _$identity);

  /// Serializes this UpdateSessionTitleParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSessionTitleParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.newTitle, newTitle) || other.newTitle == newTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,newTitle);

@override
String toString() {
  return 'UpdateSessionTitleParam(sessionId: $sessionId, newTitle: $newTitle)';
}


}

/// @nodoc
abstract mixin class $UpdateSessionTitleParamCopyWith<$Res>  {
  factory $UpdateSessionTitleParamCopyWith(UpdateSessionTitleParam value, $Res Function(UpdateSessionTitleParam) _then) = _$UpdateSessionTitleParamCopyWithImpl;
@useResult
$Res call({
 String sessionId, String newTitle
});




}
/// @nodoc
class _$UpdateSessionTitleParamCopyWithImpl<$Res>
    implements $UpdateSessionTitleParamCopyWith<$Res> {
  _$UpdateSessionTitleParamCopyWithImpl(this._self, this._then);

  final UpdateSessionTitleParam _self;
  final $Res Function(UpdateSessionTitleParam) _then;

/// Create a copy of UpdateSessionTitleParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? newTitle = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,newTitle: null == newTitle ? _self.newTitle : newTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSessionTitleParam].
extension UpdateSessionTitleParamPatterns on UpdateSessionTitleParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSessionTitleParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSessionTitleParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSessionTitleParam value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionTitleParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSessionTitleParam value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionTitleParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String newTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSessionTitleParam() when $default != null:
return $default(_that.sessionId,_that.newTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String newTitle)  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionTitleParam():
return $default(_that.sessionId,_that.newTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String newTitle)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionTitleParam() when $default != null:
return $default(_that.sessionId,_that.newTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateSessionTitleParam implements UpdateSessionTitleParam {
  const _UpdateSessionTitleParam({required this.sessionId, required this.newTitle});
  factory _UpdateSessionTitleParam.fromJson(Map<String, dynamic> json) => _$UpdateSessionTitleParamFromJson(json);

/// Identifiant de la session a mettre a jour.
@override final  String sessionId;
/// Nouveau titre de la session.
@override final  String newTitle;

/// Create a copy of UpdateSessionTitleParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSessionTitleParamCopyWith<_UpdateSessionTitleParam> get copyWith => __$UpdateSessionTitleParamCopyWithImpl<_UpdateSessionTitleParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSessionTitleParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSessionTitleParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.newTitle, newTitle) || other.newTitle == newTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,newTitle);

@override
String toString() {
  return 'UpdateSessionTitleParam(sessionId: $sessionId, newTitle: $newTitle)';
}


}

/// @nodoc
abstract mixin class _$UpdateSessionTitleParamCopyWith<$Res> implements $UpdateSessionTitleParamCopyWith<$Res> {
  factory _$UpdateSessionTitleParamCopyWith(_UpdateSessionTitleParam value, $Res Function(_UpdateSessionTitleParam) _then) = __$UpdateSessionTitleParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String newTitle
});




}
/// @nodoc
class __$UpdateSessionTitleParamCopyWithImpl<$Res>
    implements _$UpdateSessionTitleParamCopyWith<$Res> {
  __$UpdateSessionTitleParamCopyWithImpl(this._self, this._then);

  final _UpdateSessionTitleParam _self;
  final $Res Function(_UpdateSessionTitleParam) _then;

/// Create a copy of UpdateSessionTitleParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? newTitle = null,}) {
  return _then(_UpdateSessionTitleParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,newTitle: null == newTitle ? _self.newTitle : newTitle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
