import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.entity.freezed.dart';

/// Entite representant une session de transcription.
@freezed
abstract class SessionEntity with _$SessionEntity {
  /// Cree une instance de [SessionEntity].
  const factory SessionEntity({
    /// Identifiant unique de la session.
    required String id,

    /// Titre de la session.
    required String title,

    /// Date de creation de la session.
    required DateTime createdAt,

    /// Date de derniere mise a jour de la session.
    required DateTime updatedAt,

    /// Duree totale de la session en secondes.
    int? durationSeconds,

    /// Statut actuel de la session.
    required SessionStatus status,
  }) = _SessionEntity;
}
