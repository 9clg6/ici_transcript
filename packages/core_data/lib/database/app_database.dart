import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Table des sessions de transcription.
class Sessions extends Table {
  /// Identifiant unique de la session.
  TextColumn get id => text()();

  /// Titre de la session.
  TextColumn get title => text()();

  /// Date de creation au format ISO 8601.
  TextColumn get createdAt => text()();

  /// Date de derniere mise a jour au format ISO 8601.
  TextColumn get updatedAt => text()();

  /// Duree totale en secondes.
  IntColumn get durationSeconds => integer().nullable()();

  /// Statut de la session (active, completed, error).
  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// Table des segments de transcription.
class TranscriptSegments extends Table {
  /// Identifiant unique du segment.
  TextColumn get id => text()();

  /// Identifiant de la session parente.
  TextColumn get sessionId => text().references(Sessions, #id)();

  /// Source audio (input ou output).
  TextColumn get source => text()();

  /// Texte transcrit.
  TextColumn get textContent => text().named('text_content')();

  /// Offset en millisecondes depuis le debut de la session.
  IntColumn get timestampMs => integer()();

  /// Date de creation au format ISO 8601.
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// Table des resumes de session.
class Summaries extends Table {
  /// Identifiant unique du resume.
  TextColumn get id => text()();

  /// Identifiant de la session parente.
  TextColumn get sessionId => text().references(Sessions, #id)();

  /// Contenu du resume en texte.
  TextColumn get content => text()();

  /// Nom du modele utilise pour generer le resume.
  TextColumn get model => text()();

  /// Date de creation au format ISO 8601.
  TextColumn get createdAt => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{id};
}

/// Base de donnees SQLite de l'application via Drift.
@DriftDatabase(tables: <Type>[Sessions, TranscriptSegments, Summaries])
class AppDatabase extends _$AppDatabase {
  /// Cree une instance de [AppDatabase].
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
