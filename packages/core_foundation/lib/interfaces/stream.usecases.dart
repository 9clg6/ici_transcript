import 'package:core_foundation/interfaces/usecase.interfaces.dart';

/// Use case retournant un Stream sans parametres.
abstract class StreamUseCase<T> implements BaseUseCase<Stream<T>> {
  @override
  Stream<T> execute();

  /// Methode a implementer par les sous-classes.
  Stream<T> invoke();
}

/// Use case retournant un Stream avec parametres.
abstract class StreamUseCaseWithParams<T, P>
    implements BaseUseCaseWithParams<Stream<T>, P> {
  @override
  Stream<T> execute(P params);

  /// Methode a implementer par les sous-classes.
  Stream<T> invoke(P params);
}
