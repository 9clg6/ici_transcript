import 'dart:developer' as developer;

/// Logger structure pour l'application.
class Log {
  /// Cree un logger nomme.
  Log.named(this._name);

  final String _name;

  /// Log un message d'information.
  void info(String message) {
    developer.log('[$_name] INFO: $message');
  }

  /// Log un message de debug.
  void debug(String message) {
    developer.log('[$_name] DEBUG: $message');
  }

  /// Log un message d'avertissement.
  void warning(String message) {
    developer.log('[$_name] WARNING: $message');
  }

  /// Log un message d'erreur.
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      '[$_name] ERROR: $message',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
