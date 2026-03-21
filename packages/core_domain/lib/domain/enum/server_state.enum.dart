import 'package:json_annotation/json_annotation.dart';

/// Etat du serveur de transcription (voxmlx-serve).
@JsonEnum()
enum ServerState {
  /// Le serveur est en cours de demarrage.
  starting,

  /// Le serveur est pret a recevoir des connexions.
  ready,

  /// Le serveur est en erreur.
  error,

  /// Le serveur est arrete.
  stopped,
}
