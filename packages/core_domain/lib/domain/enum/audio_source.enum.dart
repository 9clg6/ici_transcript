import 'package:json_annotation/json_annotation.dart';

/// Source d'un flux audio.
@JsonEnum()
enum AudioSource {
  /// Micro de l'utilisateur (input).
  input,

  /// Audio systeme (output).
  output,
}
