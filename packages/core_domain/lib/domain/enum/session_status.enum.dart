import 'package:json_annotation/json_annotation.dart';

/// Statut d'une session de transcription.
@JsonEnum()
enum SessionStatus {
  /// Session en cours.
  active,

  /// Session terminee avec succes.
  completed,

  /// Session terminee en erreur.
  error,
}
