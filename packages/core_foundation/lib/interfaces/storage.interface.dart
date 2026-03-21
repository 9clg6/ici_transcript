/// Interface generique pour le stockage local.
abstract interface class StorageInterface<T> {
  /// Sauvegarde une valeur.
  Future<void> save(T value);

  /// Recupere la valeur stockee.
  Future<T?> get();

  /// Supprime la valeur stockee.
  Future<void> delete();

  /// Verifie si une valeur est stockee.
  Future<bool> exists();
}
