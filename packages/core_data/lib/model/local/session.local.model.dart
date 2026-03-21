import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.local.model.freezed.dart';
part 'session.local.model.g.dart';

/// Modele de donnees local pour une session de transcription (SQLite/Drift).
@freezed
abstract class SessionLocalModel with _$SessionLocalModel {
  /// Cree une instance de [SessionLocalModel].
  const factory SessionLocalModel({
    /// Identifiant unique de la session.
    required String id,

    /// Titre de la session.
    required String title,

    /// Date de creation au format ISO 8601.
    required String createdAt,

    /// Date de derniere mise a jour au format ISO 8601.
    required String updatedAt,

    /// Duree totale en secondes.
    int? durationSeconds,

    /// Statut de la session (active, completed, error).
    required String status,
  }) = _SessionLocalModel;

  /// Cree une instance depuis un JSON.
  factory SessionLocalModel.fromJson(Map<String, dynamic> json) =>
      _$SessionLocalModelFromJson(json);
}
