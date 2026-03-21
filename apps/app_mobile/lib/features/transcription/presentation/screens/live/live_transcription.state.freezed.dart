// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_transcription.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveTranscriptionState {

/// Liste des segments de transcription de la session courante.
 List<TranscriptSegmentEntity> get segments;/// Indique si un enregistrement est en cours.
 bool get isRecording;/// Indique si l'enregistrement est en pause.
 bool get isPaused;/// Duree actuelle de la session.
 Duration get duration;/// Etat du serveur de transcription.
 ServerState get serverState;/// Titre de la session en cours.
 String? get sessionTitle;/// Statut de la permission microphone.
/// Valeurs : "authorized", "denied", "notDetermined", "restricted", "unknown".
 String get micPermission;/// Statut de la permission Screen Recording.
/// Valeurs : "authorized", "denied", "notDetermined", "unknown".
 String get screenRecordingPermission;/// Indique si l'option résumé IA est activée.
 bool get isSummaryEnabled;/// Résumé IA de la session (null si pas encore généré).
 String? get summary;/// Indique si le résumé est en cours de génération.
 bool get isSummaryLoading;/// Étape courante du setup Ollama.
 OllamaSetupStage get ollamaSetupStage;/// Progression du setup Ollama (0.0 – 1.0).
 double get ollamaSetupProgress;/// Message d'erreur du setup Ollama.
 String? get ollamaSetupError;
/// Create a copy of LiveTranscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveTranscriptionStateCopyWith<LiveTranscriptionState> get copyWith => _$LiveTranscriptionStateCopyWithImpl<LiveTranscriptionState>(this as LiveTranscriptionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveTranscriptionState&&const DeepCollectionEquality().equals(other.segments, segments)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.serverState, serverState) || other.serverState == serverState)&&(identical(other.sessionTitle, sessionTitle) || other.sessionTitle == sessionTitle)&&(identical(other.micPermission, micPermission) || other.micPermission == micPermission)&&(identical(other.screenRecordingPermission, screenRecordingPermission) || other.screenRecordingPermission == screenRecordingPermission)&&(identical(other.isSummaryEnabled, isSummaryEnabled) || other.isSummaryEnabled == isSummaryEnabled)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isSummaryLoading, isSummaryLoading) || other.isSummaryLoading == isSummaryLoading)&&(identical(other.ollamaSetupStage, ollamaSetupStage) || other.ollamaSetupStage == ollamaSetupStage)&&(identical(other.ollamaSetupProgress, ollamaSetupProgress) || other.ollamaSetupProgress == ollamaSetupProgress)&&(identical(other.ollamaSetupError, ollamaSetupError) || other.ollamaSetupError == ollamaSetupError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(segments),isRecording,isPaused,duration,serverState,sessionTitle,micPermission,screenRecordingPermission,isSummaryEnabled,summary,isSummaryLoading,ollamaSetupStage,ollamaSetupProgress,ollamaSetupError);

@override
String toString() {
  return 'LiveTranscriptionState(segments: $segments, isRecording: $isRecording, isPaused: $isPaused, duration: $duration, serverState: $serverState, sessionTitle: $sessionTitle, micPermission: $micPermission, screenRecordingPermission: $screenRecordingPermission, isSummaryEnabled: $isSummaryEnabled, summary: $summary, isSummaryLoading: $isSummaryLoading, ollamaSetupStage: $ollamaSetupStage, ollamaSetupProgress: $ollamaSetupProgress, ollamaSetupError: $ollamaSetupError)';
}


}

/// @nodoc
abstract mixin class $LiveTranscriptionStateCopyWith<$Res>  {
  factory $LiveTranscriptionStateCopyWith(LiveTranscriptionState value, $Res Function(LiveTranscriptionState) _then) = _$LiveTranscriptionStateCopyWithImpl;
@useResult
$Res call({
 List<TranscriptSegmentEntity> segments, bool isRecording, bool isPaused, Duration duration, ServerState serverState, String? sessionTitle, String micPermission, String screenRecordingPermission, bool isSummaryEnabled, String? summary, bool isSummaryLoading, OllamaSetupStage ollamaSetupStage, double ollamaSetupProgress, String? ollamaSetupError
});




}
/// @nodoc
class _$LiveTranscriptionStateCopyWithImpl<$Res>
    implements $LiveTranscriptionStateCopyWith<$Res> {
  _$LiveTranscriptionStateCopyWithImpl(this._self, this._then);

  final LiveTranscriptionState _self;
  final $Res Function(LiveTranscriptionState) _then;

/// Create a copy of LiveTranscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? segments = null,Object? isRecording = null,Object? isPaused = null,Object? duration = null,Object? serverState = null,Object? sessionTitle = freezed,Object? micPermission = null,Object? screenRecordingPermission = null,Object? isSummaryEnabled = null,Object? summary = freezed,Object? isSummaryLoading = null,Object? ollamaSetupStage = null,Object? ollamaSetupProgress = null,Object? ollamaSetupError = freezed,}) {
  return _then(_self.copyWith(
segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,serverState: null == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as ServerState,sessionTitle: freezed == sessionTitle ? _self.sessionTitle : sessionTitle // ignore: cast_nullable_to_non_nullable
as String?,micPermission: null == micPermission ? _self.micPermission : micPermission // ignore: cast_nullable_to_non_nullable
as String,screenRecordingPermission: null == screenRecordingPermission ? _self.screenRecordingPermission : screenRecordingPermission // ignore: cast_nullable_to_non_nullable
as String,isSummaryEnabled: null == isSummaryEnabled ? _self.isSummaryEnabled : isSummaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,isSummaryLoading: null == isSummaryLoading ? _self.isSummaryLoading : isSummaryLoading // ignore: cast_nullable_to_non_nullable
as bool,ollamaSetupStage: null == ollamaSetupStage ? _self.ollamaSetupStage : ollamaSetupStage // ignore: cast_nullable_to_non_nullable
as OllamaSetupStage,ollamaSetupProgress: null == ollamaSetupProgress ? _self.ollamaSetupProgress : ollamaSetupProgress // ignore: cast_nullable_to_non_nullable
as double,ollamaSetupError: freezed == ollamaSetupError ? _self.ollamaSetupError : ollamaSetupError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveTranscriptionState].
extension LiveTranscriptionStatePatterns on LiveTranscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveTranscriptionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveTranscriptionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveTranscriptionState value)  $default,){
final _that = this;
switch (_that) {
case _LiveTranscriptionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveTranscriptionState value)?  $default,){
final _that = this;
switch (_that) {
case _LiveTranscriptionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TranscriptSegmentEntity> segments,  bool isRecording,  bool isPaused,  Duration duration,  ServerState serverState,  String? sessionTitle,  String micPermission,  String screenRecordingPermission,  bool isSummaryEnabled,  String? summary,  bool isSummaryLoading,  OllamaSetupStage ollamaSetupStage,  double ollamaSetupProgress,  String? ollamaSetupError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveTranscriptionState() when $default != null:
return $default(_that.segments,_that.isRecording,_that.isPaused,_that.duration,_that.serverState,_that.sessionTitle,_that.micPermission,_that.screenRecordingPermission,_that.isSummaryEnabled,_that.summary,_that.isSummaryLoading,_that.ollamaSetupStage,_that.ollamaSetupProgress,_that.ollamaSetupError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TranscriptSegmentEntity> segments,  bool isRecording,  bool isPaused,  Duration duration,  ServerState serverState,  String? sessionTitle,  String micPermission,  String screenRecordingPermission,  bool isSummaryEnabled,  String? summary,  bool isSummaryLoading,  OllamaSetupStage ollamaSetupStage,  double ollamaSetupProgress,  String? ollamaSetupError)  $default,) {final _that = this;
switch (_that) {
case _LiveTranscriptionState():
return $default(_that.segments,_that.isRecording,_that.isPaused,_that.duration,_that.serverState,_that.sessionTitle,_that.micPermission,_that.screenRecordingPermission,_that.isSummaryEnabled,_that.summary,_that.isSummaryLoading,_that.ollamaSetupStage,_that.ollamaSetupProgress,_that.ollamaSetupError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TranscriptSegmentEntity> segments,  bool isRecording,  bool isPaused,  Duration duration,  ServerState serverState,  String? sessionTitle,  String micPermission,  String screenRecordingPermission,  bool isSummaryEnabled,  String? summary,  bool isSummaryLoading,  OllamaSetupStage ollamaSetupStage,  double ollamaSetupProgress,  String? ollamaSetupError)?  $default,) {final _that = this;
switch (_that) {
case _LiveTranscriptionState() when $default != null:
return $default(_that.segments,_that.isRecording,_that.isPaused,_that.duration,_that.serverState,_that.sessionTitle,_that.micPermission,_that.screenRecordingPermission,_that.isSummaryEnabled,_that.summary,_that.isSummaryLoading,_that.ollamaSetupStage,_that.ollamaSetupProgress,_that.ollamaSetupError);case _:
  return null;

}
}

}

/// @nodoc


class _LiveTranscriptionState implements LiveTranscriptionState {
  const _LiveTranscriptionState({required final  List<TranscriptSegmentEntity> segments, this.isRecording = false, this.isPaused = false, this.duration = Duration.zero, this.serverState = ServerState.stopped, this.sessionTitle, this.micPermission = 'unknown', this.screenRecordingPermission = 'unknown', this.isSummaryEnabled = false, this.summary, this.isSummaryLoading = false, this.ollamaSetupStage = OllamaSetupStage.idle, this.ollamaSetupProgress = 0.0, this.ollamaSetupError}): _segments = segments;
  

/// Liste des segments de transcription de la session courante.
 final  List<TranscriptSegmentEntity> _segments;
/// Liste des segments de transcription de la session courante.
@override List<TranscriptSegmentEntity> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

/// Indique si un enregistrement est en cours.
@override@JsonKey() final  bool isRecording;
/// Indique si l'enregistrement est en pause.
@override@JsonKey() final  bool isPaused;
/// Duree actuelle de la session.
@override@JsonKey() final  Duration duration;
/// Etat du serveur de transcription.
@override@JsonKey() final  ServerState serverState;
/// Titre de la session en cours.
@override final  String? sessionTitle;
/// Statut de la permission microphone.
/// Valeurs : "authorized", "denied", "notDetermined", "restricted", "unknown".
@override@JsonKey() final  String micPermission;
/// Statut de la permission Screen Recording.
/// Valeurs : "authorized", "denied", "notDetermined", "unknown".
@override@JsonKey() final  String screenRecordingPermission;
/// Indique si l'option résumé IA est activée.
@override@JsonKey() final  bool isSummaryEnabled;
/// Résumé IA de la session (null si pas encore généré).
@override final  String? summary;
/// Indique si le résumé est en cours de génération.
@override@JsonKey() final  bool isSummaryLoading;
/// Étape courante du setup Ollama.
@override@JsonKey() final  OllamaSetupStage ollamaSetupStage;
/// Progression du setup Ollama (0.0 – 1.0).
@override@JsonKey() final  double ollamaSetupProgress;
/// Message d'erreur du setup Ollama.
@override final  String? ollamaSetupError;

/// Create a copy of LiveTranscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveTranscriptionStateCopyWith<_LiveTranscriptionState> get copyWith => __$LiveTranscriptionStateCopyWithImpl<_LiveTranscriptionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveTranscriptionState&&const DeepCollectionEquality().equals(other._segments, _segments)&&(identical(other.isRecording, isRecording) || other.isRecording == isRecording)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.serverState, serverState) || other.serverState == serverState)&&(identical(other.sessionTitle, sessionTitle) || other.sessionTitle == sessionTitle)&&(identical(other.micPermission, micPermission) || other.micPermission == micPermission)&&(identical(other.screenRecordingPermission, screenRecordingPermission) || other.screenRecordingPermission == screenRecordingPermission)&&(identical(other.isSummaryEnabled, isSummaryEnabled) || other.isSummaryEnabled == isSummaryEnabled)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isSummaryLoading, isSummaryLoading) || other.isSummaryLoading == isSummaryLoading)&&(identical(other.ollamaSetupStage, ollamaSetupStage) || other.ollamaSetupStage == ollamaSetupStage)&&(identical(other.ollamaSetupProgress, ollamaSetupProgress) || other.ollamaSetupProgress == ollamaSetupProgress)&&(identical(other.ollamaSetupError, ollamaSetupError) || other.ollamaSetupError == ollamaSetupError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_segments),isRecording,isPaused,duration,serverState,sessionTitle,micPermission,screenRecordingPermission,isSummaryEnabled,summary,isSummaryLoading,ollamaSetupStage,ollamaSetupProgress,ollamaSetupError);

@override
String toString() {
  return 'LiveTranscriptionState(segments: $segments, isRecording: $isRecording, isPaused: $isPaused, duration: $duration, serverState: $serverState, sessionTitle: $sessionTitle, micPermission: $micPermission, screenRecordingPermission: $screenRecordingPermission, isSummaryEnabled: $isSummaryEnabled, summary: $summary, isSummaryLoading: $isSummaryLoading, ollamaSetupStage: $ollamaSetupStage, ollamaSetupProgress: $ollamaSetupProgress, ollamaSetupError: $ollamaSetupError)';
}


}

/// @nodoc
abstract mixin class _$LiveTranscriptionStateCopyWith<$Res> implements $LiveTranscriptionStateCopyWith<$Res> {
  factory _$LiveTranscriptionStateCopyWith(_LiveTranscriptionState value, $Res Function(_LiveTranscriptionState) _then) = __$LiveTranscriptionStateCopyWithImpl;
@override @useResult
$Res call({
 List<TranscriptSegmentEntity> segments, bool isRecording, bool isPaused, Duration duration, ServerState serverState, String? sessionTitle, String micPermission, String screenRecordingPermission, bool isSummaryEnabled, String? summary, bool isSummaryLoading, OllamaSetupStage ollamaSetupStage, double ollamaSetupProgress, String? ollamaSetupError
});




}
/// @nodoc
class __$LiveTranscriptionStateCopyWithImpl<$Res>
    implements _$LiveTranscriptionStateCopyWith<$Res> {
  __$LiveTranscriptionStateCopyWithImpl(this._self, this._then);

  final _LiveTranscriptionState _self;
  final $Res Function(_LiveTranscriptionState) _then;

/// Create a copy of LiveTranscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? segments = null,Object? isRecording = null,Object? isPaused = null,Object? duration = null,Object? serverState = null,Object? sessionTitle = freezed,Object? micPermission = null,Object? screenRecordingPermission = null,Object? isSummaryEnabled = null,Object? summary = freezed,Object? isSummaryLoading = null,Object? ollamaSetupStage = null,Object? ollamaSetupProgress = null,Object? ollamaSetupError = freezed,}) {
  return _then(_LiveTranscriptionState(
segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegmentEntity>,isRecording: null == isRecording ? _self.isRecording : isRecording // ignore: cast_nullable_to_non_nullable
as bool,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,serverState: null == serverState ? _self.serverState : serverState // ignore: cast_nullable_to_non_nullable
as ServerState,sessionTitle: freezed == sessionTitle ? _self.sessionTitle : sessionTitle // ignore: cast_nullable_to_non_nullable
as String?,micPermission: null == micPermission ? _self.micPermission : micPermission // ignore: cast_nullable_to_non_nullable
as String,screenRecordingPermission: null == screenRecordingPermission ? _self.screenRecordingPermission : screenRecordingPermission // ignore: cast_nullable_to_non_nullable
as String,isSummaryEnabled: null == isSummaryEnabled ? _self.isSummaryEnabled : isSummaryEnabled // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,isSummaryLoading: null == isSummaryLoading ? _self.isSummaryLoading : isSummaryLoading // ignore: cast_nullable_to_non_nullable
as bool,ollamaSetupStage: null == ollamaSetupStage ? _self.ollamaSetupStage : ollamaSetupStage // ignore: cast_nullable_to_non_nullable
as OllamaSetupStage,ollamaSetupProgress: null == ollamaSetupProgress ? _self.ollamaSetupProgress : ollamaSetupProgress // ignore: cast_nullable_to_non_nullable
as double,ollamaSetupError: freezed == ollamaSetupError ? _self.ollamaSetupError : ollamaSetupError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
