// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ollama_setup.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OllamaSetupState {

/// Etape courante.
 OllamaSetupStage get stage;/// Progression de l'etape courante (0.0 – 1.0).
 double get progress;/// Ollama est completement pret.
 bool get isReady;/// Message d'erreur si echec.
 String? get error;
/// Create a copy of OllamaSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OllamaSetupStateCopyWith<OllamaSetupState> get copyWith => _$OllamaSetupStateCopyWithImpl<OllamaSetupState>(this as OllamaSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OllamaSetupState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,stage,progress,isReady,error);

@override
String toString() {
  return 'OllamaSetupState(stage: $stage, progress: $progress, isReady: $isReady, error: $error)';
}


}

/// @nodoc
abstract mixin class $OllamaSetupStateCopyWith<$Res>  {
  factory $OllamaSetupStateCopyWith(OllamaSetupState value, $Res Function(OllamaSetupState) _then) = _$OllamaSetupStateCopyWithImpl;
@useResult
$Res call({
 OllamaSetupStage stage, double progress, bool isReady, String? error
});




}
/// @nodoc
class _$OllamaSetupStateCopyWithImpl<$Res>
    implements $OllamaSetupStateCopyWith<$Res> {
  _$OllamaSetupStateCopyWithImpl(this._self, this._then);

  final OllamaSetupState _self;
  final $Res Function(OllamaSetupState) _then;

/// Create a copy of OllamaSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? progress = null,Object? isReady = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OllamaSetupStage,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OllamaSetupState].
extension OllamaSetupStatePatterns on OllamaSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OllamaSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OllamaSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OllamaSetupState value)  $default,){
final _that = this;
switch (_that) {
case _OllamaSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OllamaSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _OllamaSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OllamaSetupStage stage,  double progress,  bool isReady,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OllamaSetupState() when $default != null:
return $default(_that.stage,_that.progress,_that.isReady,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OllamaSetupStage stage,  double progress,  bool isReady,  String? error)  $default,) {final _that = this;
switch (_that) {
case _OllamaSetupState():
return $default(_that.stage,_that.progress,_that.isReady,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OllamaSetupStage stage,  double progress,  bool isReady,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _OllamaSetupState() when $default != null:
return $default(_that.stage,_that.progress,_that.isReady,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _OllamaSetupState implements OllamaSetupState {
  const _OllamaSetupState({this.stage = OllamaSetupStage.idle, this.progress = 0.0, this.isReady = false, this.error});
  

/// Etape courante.
@override@JsonKey() final  OllamaSetupStage stage;
/// Progression de l'etape courante (0.0 – 1.0).
@override@JsonKey() final  double progress;
/// Ollama est completement pret.
@override@JsonKey() final  bool isReady;
/// Message d'erreur si echec.
@override final  String? error;

/// Create a copy of OllamaSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OllamaSetupStateCopyWith<_OllamaSetupState> get copyWith => __$OllamaSetupStateCopyWithImpl<_OllamaSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OllamaSetupState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,stage,progress,isReady,error);

@override
String toString() {
  return 'OllamaSetupState(stage: $stage, progress: $progress, isReady: $isReady, error: $error)';
}


}

/// @nodoc
abstract mixin class _$OllamaSetupStateCopyWith<$Res> implements $OllamaSetupStateCopyWith<$Res> {
  factory _$OllamaSetupStateCopyWith(_OllamaSetupState value, $Res Function(_OllamaSetupState) _then) = __$OllamaSetupStateCopyWithImpl;
@override @useResult
$Res call({
 OllamaSetupStage stage, double progress, bool isReady, String? error
});




}
/// @nodoc
class __$OllamaSetupStateCopyWithImpl<$Res>
    implements _$OllamaSetupStateCopyWith<$Res> {
  __$OllamaSetupStateCopyWithImpl(this._self, this._then);

  final _OllamaSetupState _self;
  final $Res Function(_OllamaSetupState) _then;

/// Create a copy of OllamaSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? progress = null,Object? isReady = null,Object? error = freezed,}) {
  return _then(_OllamaSetupState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OllamaSetupStage,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
