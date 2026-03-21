import 'package:core_foundation/enum/environment.enum.dart';

/// Configuration abstraite de l'application.
abstract class AppConfig {
  /// Cree une instance de [AppConfig].
  const AppConfig({
    required this.appName,
    required this.baseUrl,
    required this.env,
  });

  /// Environnement courant.
  final Environment env;

  /// Nom de l'application.
  final String appName;

  /// URL de base de l'API.
  final String baseUrl;

  /// Indique si c'est la production.
  bool get isProd => env == Environment.production;
}
