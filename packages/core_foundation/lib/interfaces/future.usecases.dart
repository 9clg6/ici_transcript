import 'package:core_foundation/interfaces/results.usecases.dart';
import 'package:core_foundation/interfaces/usecase.interfaces.dart';

/// Helper pour wraper un Future avec try/catch et timeout.
Future<ResultState<T>> _futureCatcher<T>(Future<T> Function() action) async {
  try {
    final T result = await action().timeout(const Duration(seconds: 15));
    return ResultState<T>.success(result);
  } on Exception catch (e) {
    return ResultState<T>.failure(e);
  }
}

/// Use case asynchrone sans parametres.
abstract class FutureUseCase<T> implements BaseUseCase<Future<ResultState<T>>> {
  @override
  Future<ResultState<T>> execute() async => _futureCatcher(invoke);

  /// Methode a implementer par les sous-classes.
  Future<T> invoke();
}

/// Use case asynchrone avec parametres.
abstract class FutureUseCaseWithParams<T, P>
    implements BaseUseCaseWithParams<Future<ResultState<T>>, P> {
  @override
  Future<ResultState<T>> execute(P params) async =>
      _futureCatcher(() => invoke(params));

  /// Methode a implementer par les sous-classes.
  Future<T> invoke(P params);
}
