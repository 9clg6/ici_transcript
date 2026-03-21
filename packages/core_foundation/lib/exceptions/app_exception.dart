/// Exception de base de l'application.
class AppException implements Exception {
  /// Cree une instance de [AppException].
  const AppException({required this.message, this.code, this.stackTrace});

  /// Message d'erreur.
  final String message;

  /// Code d'erreur optionnel.
  final String? code;

  /// Stack trace optionnelle.
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Exception reseau.
class NetworkException extends AppException {
  /// Cree une instance de [NetworkException].
  const NetworkException({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });

  /// Code de statut HTTP.
  final int? statusCode;

  @override
  String toString() =>
      'NetworkException(statusCode: $statusCode, message: $message)';
}

/// Exception d'authentification.
class AuthException extends AppException {
  /// Cree une instance de [AuthException].
  const AuthException({required super.message, super.code, super.stackTrace});

  @override
  String toString() => 'AuthException(message: $message)';
}
