import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary.entity.freezed.dart';

/// Entite representant un resume de session.
@freezed
abstract class SummaryEntity with _$SummaryEntity {
  /// Cree une instance de [SummaryEntity].
  const factory SummaryEntity({
    /// Identifiant unique du resume.
    required String id,

    /// Identifiant de la session parente.
    required String sessionId,

    /// Contenu du resume en texte.
    required String content,

    /// Nom du modele utilise pour generer le resume.
    required String model,

    /// Date de creation du resume.
    required DateTime createdAt,
  }) = _SummaryEntity;
}
