import 'package:core_data/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.provider.g.dart';

/// Provider singleton pour [AppDatabase] (Drift/SQLite).
///
/// Initialise la base de donnees locale avec NativeDatabase
/// et la maintient ouverte pendant toute la duree de vie de l'app.
@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final AppDatabase db = AppDatabase(NativeDatabase.memory());
  ref.onDispose(db.close);
  return db;
}
