import 'package:json_annotation/json_annotation.dart';

/// Etat de la connexion WebSocket au serveur de transcription.
@JsonEnum()
enum ConnectionState {
  /// Connexion en cours.
  connecting,

  /// Connexion etablie.
  connected,

  /// Connexion perdue.
  disconnected,

  /// Connexion en erreur.
  error,
}
