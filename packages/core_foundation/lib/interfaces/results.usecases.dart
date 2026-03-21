/// Resultat d'un use case : succes ou echec.
class ResultState<T> {
  ResultState._({this.data, this.exception});

  /// Cree un resultat de succes.
  factory ResultState.success(T data) => ResultState<T>._(data: data);

  /// Cree un resultat d'echec.
  factory ResultState.failure(Exception exception) =>
      ResultState<T>._(exception: exception);

  /// Donnees en cas de succes.
  final T? data;

  /// Exception en cas d'echec.
  final Exception? exception;

  /// Indique si le resultat est un succes.
  bool get isSuccess => data != null && exception == null;

  /// Indique si le resultat est un echec.
  bool get isFailure => exception != null;

  /// Applique un callback selon le resultat.
  R? when<R>({
    R Function(T data)? success,
    R Function(Exception exception)? failure,
  }) {
    if (isSuccess && success != null) {
      return success(data as T);
    } else if (isFailure && failure != null) {
      return failure(exception!);
    }
    return null;
  }
}
