// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summary.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SummaryEntity {

/// Identifiant unique du resume.
 String get id;/// Identifiant de la session parente.
 String get sessionId;/// Contenu du resume en texte.
 String get content;/// Nom du modele utilise pour generer le resume.
 String get model;/// Date de creation du resume.
 DateTime get createdAt;
/// Create a copy of SummaryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SummaryEntityCopyWith<SummaryEntity> get copyWith => _$SummaryEntityCopyWithImpl<SummaryEntity>(this as SummaryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SummaryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.content, content) || other.content == content)&&(identical(other.model, model) || other.model == model)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,content,model,createdAt);

@override
String toString() {
  return 'SummaryEntity(id: $id, sessionId: $sessionId, content: $content, model: $model, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SummaryEntityCopyWith<$Res>  {
  factory $SummaryEntityCopyWith(SummaryEntity value, $Res Function(SummaryEntity) _then) = _$SummaryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String content, String model, DateTime createdAt
});




}
/// @nodoc
class _$SummaryEntityCopyWithImpl<$Res>
    implements $SummaryEntityCopyWith<$Res> {
  _$SummaryEntityCopyWithImpl(this._self, this._then);

  final SummaryEntity _self;
  final $Res Function(SummaryEntity) _then;

/// Create a copy of SummaryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? content = null,Object? model = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SummaryEntity].
extension SummaryEntityPatterns on SummaryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SummaryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SummaryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SummaryEntity value)  $default,){
final _that = this;
switch (_that) {
case _SummaryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SummaryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SummaryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String content,  String model,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SummaryEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.content,_that.model,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String content,  String model,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SummaryEntity():
return $default(_that.id,_that.sessionId,_that.content,_that.model,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String content,  String model,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SummaryEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.content,_that.model,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _SummaryEntity implements SummaryEntity {
  const _SummaryEntity({required this.id, required this.sessionId, required this.content, required this.model, required this.createdAt});
  

/// Identifiant unique du resume.
@override final  String id;
/// Identifiant de la session parente.
@override final  String sessionId;
/// Contenu du resume en texte.
@override final  String content;
/// Nom du modele utilise pour generer le resume.
@override final  String model;
/// Date de creation du resume.
@override final  DateTime createdAt;

/// Create a copy of SummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SummaryEntityCopyWith<_SummaryEntity> get copyWith => __$SummaryEntityCopyWithImpl<_SummaryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SummaryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.content, content) || other.content == content)&&(identical(other.model, model) || other.model == model)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,content,model,createdAt);

@override
String toString() {
  return 'SummaryEntity(id: $id, sessionId: $sessionId, content: $content, model: $model, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SummaryEntityCopyWith<$Res> implements $SummaryEntityCopyWith<$Res> {
  factory _$SummaryEntityCopyWith(_SummaryEntity value, $Res Function(_SummaryEntity) _then) = __$SummaryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String content, String model, DateTime createdAt
});




}
/// @nodoc
class __$SummaryEntityCopyWithImpl<$Res>
    implements _$SummaryEntityCopyWith<$Res> {
  __$SummaryEntityCopyWithImpl(this._self, this._then);

  final _SummaryEntity _self;
  final $Res Function(_SummaryEntity) _then;

/// Create a copy of SummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? content = null,Object? model = null,Object? createdAt = null,}) {
  return _then(_SummaryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
