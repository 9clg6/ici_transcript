/// Interface de base pour les use cases sans parametres.
abstract class BaseUseCase<T> {
  /// Execute le use case.
  T execute();
}

/// Interface de base pour les use cases avec parametres.
abstract class BaseUseCaseWithParams<T, P> {
  /// Execute le use case avec les parametres donnes.
  T execute(P params);
}
