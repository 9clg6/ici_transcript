import 'package:core_domain/domain/entities/session.entity.dart';

/// Contrat du repository de sessions de transcription.
abstract interface class SessionRepository {
  /// Recupere toutes les sessions.
  Future<List<SessionEntity>> getAll();

  /// Recupere une session par son identifiant.
  Future<SessionEntity?> getById(String id);

  /// Cree une nouvelle session.
  Future<SessionEntity> create(SessionEntity session);

  /// Met a jour une session existante.
  Future<SessionEntity> update(SessionEntity session);

  /// Supprime une session par son identifiant.
  Future<void> delete(String id);

  /// Stream reactif de toutes les sessions.
  Stream<List<SessionEntity>> watchAll();
}
