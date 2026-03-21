// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_device.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioDeviceEntity {

/// Identifiant unique du peripherique.
 String get id;/// Nom du peripherique audio.
 String get name;/// Indique si le peripherique est un input (micro).
 bool get isInput;
/// Create a copy of AudioDeviceEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioDeviceEntityCopyWith<AudioDeviceEntity> get copyWith => _$AudioDeviceEntityCopyWithImpl<AudioDeviceEntity>(this as AudioDeviceEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioDeviceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isInput, isInput) || other.isInput == isInput));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isInput);

@override
String toString() {
  return 'AudioDeviceEntity(id: $id, name: $name, isInput: $isInput)';
}


}

/// @nodoc
abstract mixin class $AudioDeviceEntityCopyWith<$Res>  {
  factory $AudioDeviceEntityCopyWith(AudioDeviceEntity value, $Res Function(AudioDeviceEntity) _then) = _$AudioDeviceEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isInput
});




}
/// @nodoc
class _$AudioDeviceEntityCopyWithImpl<$Res>
    implements $AudioDeviceEntityCopyWith<$Res> {
  _$AudioDeviceEntityCopyWithImpl(this._self, this._then);

  final AudioDeviceEntity _self;
  final $Res Function(AudioDeviceEntity) _then;

/// Create a copy of AudioDeviceEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isInput = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isInput: null == isInput ? _self.isInput : isInput // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioDeviceEntity].
extension AudioDeviceEntityPatterns on AudioDeviceEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioDeviceEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioDeviceEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioDeviceEntity value)  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioDeviceEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AudioDeviceEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isInput)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioDeviceEntity() when $default != null:
return $default(_that.id,_that.name,_that.isInput);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isInput)  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceEntity():
return $default(_that.id,_that.name,_that.isInput);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isInput)?  $default,) {final _that = this;
switch (_that) {
case _AudioDeviceEntity() when $default != null:
return $default(_that.id,_that.name,_that.isInput);case _:
  return null;

}
}

}

/// @nodoc


class _AudioDeviceEntity implements AudioDeviceEntity {
  const _AudioDeviceEntity({required this.id, required this.name, required this.isInput});
  

/// Identifiant unique du peripherique.
@override final  String id;
/// Nom du peripherique audio.
@override final  String name;
/// Indique si le peripherique est un input (micro).
@override final  bool isInput;

/// Create a copy of AudioDeviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioDeviceEntityCopyWith<_AudioDeviceEntity> get copyWith => __$AudioDeviceEntityCopyWithImpl<_AudioDeviceEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioDeviceEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isInput, isInput) || other.isInput == isInput));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isInput);

@override
String toString() {
  return 'AudioDeviceEntity(id: $id, name: $name, isInput: $isInput)';
}


}

/// @nodoc
abstract mixin class _$AudioDeviceEntityCopyWith<$Res> implements $AudioDeviceEntityCopyWith<$Res> {
  factory _$AudioDeviceEntityCopyWith(_AudioDeviceEntity value, $Res Function(_AudioDeviceEntity) _then) = __$AudioDeviceEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isInput
});




}
/// @nodoc
class __$AudioDeviceEntityCopyWithImpl<$Res>
    implements _$AudioDeviceEntityCopyWith<$Res> {
  __$AudioDeviceEntityCopyWithImpl(this._self, this._then);

  final _AudioDeviceEntity _self;
  final $Res Function(_AudioDeviceEntity) _then;

/// Create a copy of AudioDeviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isInput = null,}) {
  return _then(_AudioDeviceEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isInput: null == isInput ? _self.isInput : isInput // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
