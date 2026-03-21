import 'dart:io';

import 'package:core_foundation/logging/logger.dart';
import 'package:dio/dio.dart';

/// Service responsable du cycle de vie du daemon Ollama.
///
/// Vérifie si Ollama tourne, le démarre si nécessaire, et vérifie
/// que le modèle cible est disponible.
class OllamaService {
  OllamaService();

  final Log _log = Log.named('OllamaService');
  static const String _baseUrl = 'http://localhost:11434';
  Process? _ollamaProcess;

  /// S'assure qu'Ollama est démarré et que le modèle [_model] est disponible.
  ///
  /// 1. Si le serveur répond déjà → rien à faire.
  /// 2. Sinon → démarre `ollama serve` en arrière-plan.
  /// 3. Attend que le serveur soit prêt (max 30s).
  Future<void> ensureReady() async {
    if (await _isServerRunning()) {
      _log.info('Ollama déjà en cours');
      return;
    }

    _log.info('Ollama non démarré, lancement de "ollama serve"...');
    await _startServer();
  }

  /// Vérifie si Ollama est joignable.
  Future<bool> _isServerRunning() async {
    try {
      final Dio dio = Dio()
        ..options.connectTimeout = const Duration(seconds: 2)
        ..options.receiveTimeout = const Duration(seconds: 2);
      final Response<dynamic> response = await dio.get<dynamic>('$_baseUrl/api/tags');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Démarre `ollama serve` et attend qu'il soit prêt.
  Future<void> _startServer() async {
    final String ollamaPath = await _resolveOllamaPath();
    if (ollamaPath.isEmpty) {
      throw Exception(
        'Ollama introuvable. Installez-le via https://ollama.com',
      );
    }

    _log.info('Lancement: $ollamaPath serve');
    _ollamaProcess = await Process.start(
      ollamaPath,
      <String>['serve'],
      environment: <String, String>{
        'HOME': Platform.environment['HOME'] ?? '/Users/unknown',
        'PATH': _extendedPath(),
      },
      mode: ProcessStartMode.detachedWithStdio,
    );

    // Logger stdout/stderr en arrière-plan
    _ollamaProcess!.stdout
        .transform(const SystemEncoding().decoder)
        .listen((String line) => _log.debug('[ollama] $line'));
    _ollamaProcess!.stderr
        .transform(const SystemEncoding().decoder)
        .listen((String line) => _log.debug('[ollama-err] $line'));

    // Attendre que le serveur réponde (timeout 30s)
    const int maxAttempts = 30;
    for (int i = 0; i < maxAttempts; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (await _isServerRunning()) {
        _log.info('Ollama prêt après ${i + 1}s');
        return;
      }
    }

    throw Exception(
      'Ollama ne répond pas après 30s. Vérifiez l\'installation.',
    );
  }

  /// Résout le chemin absolu de la commande `ollama`.
  Future<String> _resolveOllamaPath() async {
    for (final String dir in _extendedPath().split(':')) {
      if (dir.isEmpty) continue;
      final File candidate = File('$dir/ollama');
      if (await candidate.exists()) {
        _log.info('ollama trouvé: ${candidate.path}');
        return candidate.path;
      }
    }
    _log.warning('ollama non trouvé dans le PATH étendu');
    return '';
  }

  /// PATH étendu incluant les emplacements courants d'Ollama.
  String _extendedPath() {
    final String home = Platform.environment['HOME'] ?? '/Users/unknown';
    final String currentPath = Platform.environment['PATH'] ?? '';
    return <String>[
      '$home/.local/bin',
      '/opt/homebrew/bin',
      '/usr/local/bin',
      '/Applications/Ollama.app/Contents/Resources',
      currentPath,
    ].join(':');
  }

  /// Arrête le processus Ollama démarré par ce service (si lancé par l'app).
  Future<void> dispose() async {
    _ollamaProcess?.kill(ProcessSignal.sigterm);
    _ollamaProcess = null;
  }
}
