// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionListState {

/// Liste de toutes les sessions.
 List<SessionEntity> get sessions;/// Identifiant de la session actuellement selectionnee.
 String? get selectedSessionId;/// Requete de recherche en cours.
 String get searchQuery;
/// Create a copy of SessionListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionListStateCopyWith<SessionListState> get copyWith => _$SessionListStateCopyWithImpl<SessionListState>(this as SessionListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionListState&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.selectedSessionId, selectedSessionId) || other.selectedSessionId == selectedSessionId)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions),selectedSessionId,searchQuery);

@override
String toString() {
  return 'SessionListState(sessions: $sessions, selectedSessionId: $selectedSessionId, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $SessionListStateCopyWith<$Res>  {
  factory $SessionListStateCopyWith(SessionListState value, $Res Function(SessionListState) _then) = _$SessionListStateCopyWithImpl;
@useResult
$Res call({
 List<SessionEntity> sessions, String? selectedSessionId, String searchQuery
});




}
/// @nodoc
class _$SessionListStateCopyWithImpl<$Res>
    implements $SessionListStateCopyWith<$Res> {
  _$SessionListStateCopyWithImpl(this._self, this._then);

  final SessionListState _self;
  final $Res Function(SessionListState) _then;

/// Create a copy of SessionListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? selectedSessionId = freezed,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionEntity>,selectedSessionId: freezed == selectedSessionId ? _self.selectedSessionId : selectedSessionId // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionListState].
extension SessionListStatePatterns on SessionListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionListState value)  $default,){
final _that = this;
switch (_that) {
case _SessionListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionListState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SessionEntity> sessions,  String? selectedSessionId,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionListState() when $default != null:
return $default(_that.sessions,_that.selectedSessionId,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SessionEntity> sessions,  String? selectedSessionId,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _SessionListState():
return $default(_that.sessions,_that.selectedSessionId,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SessionEntity> sessions,  String? selectedSessionId,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _SessionListState() when $default != null:
return $default(_that.sessions,_that.selectedSessionId,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _SessionListState implements SessionListState {
  const _SessionListState({required final  List<SessionEntity> sessions, this.selectedSessionId, this.searchQuery = ''}): _sessions = sessions;
  

/// Liste de toutes les sessions.
 final  List<SessionEntity> _sessions;
/// Liste de toutes les sessions.
@override List<SessionEntity> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

/// Identifiant de la session actuellement selectionnee.
@override final  String? selectedSessionId;
/// Requete de recherche en cours.
@override@JsonKey() final  String searchQuery;

/// Create a copy of SessionListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionListStateCopyWith<_SessionListState> get copyWith => __$SessionListStateCopyWithImpl<_SessionListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionListState&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&(identical(other.selectedSessionId, selectedSessionId) || other.selectedSessionId == selectedSessionId)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),selectedSessionId,searchQuery);

@override
String toString() {
  return 'SessionListState(sessions: $sessions, selectedSessionId: $selectedSessionId, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$SessionListStateCopyWith<$Res> implements $SessionListStateCopyWith<$Res> {
  factory _$SessionListStateCopyWith(_SessionListState value, $Res Function(_SessionListState) _then) = __$SessionListStateCopyWithImpl;
@override @useResult
$Res call({
 List<SessionEntity> sessions, String? selectedSessionId, String searchQuery
});




}
/// @nodoc
class __$SessionListStateCopyWithImpl<$Res>
    implements _$SessionListStateCopyWith<$Res> {
  __$SessionListStateCopyWithImpl(this._self, this._then);

  final _SessionListState _self;
  final $Res Function(_SessionListState) _then;

/// Create a copy of SessionListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? selectedSessionId = freezed,Object? searchQuery = null,}) {
  return _then(_SessionListState(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionEntity>,selectedSessionId: freezed == selectedSessionId ? _self.selectedSessionId : selectedSessionId // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
