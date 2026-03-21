import 'package:ici_transcript/application/services/ollama.service.dart';
import 'package:ici_transcript/core/providers/services/ollama.service.provider.dart';
import 'package:ici_transcript/features/onboarding/presentation/ollama_setup.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ollama_setup.view_model.g.dart';

/// ViewModel du processus de configuration initiale d'Ollama.
///
/// Surveille et déclenche le téléchargement du binaire Ollama et du modèle
/// Mistral si nécessaire. Appelé une seule fois au démarrage de l'app.
@Riverpod(keepAlive: true)
class OllamaSetupViewModel extends _$OllamaSetupViewModel {
  @override
  OllamaSetupState build() {
    _startSetup();
    return const OllamaSetupState();
  }

  Future<void> _startSetup() async {
    try {
      await ref.read(ollamaServiceProvider).ensureReady(
        onProgress: (OllamaSetupStage stage, double progress) {
          state = state.copyWith(stage: stage, progress: progress);
        },
      );
      state = state.copyWith(
        stage: OllamaSetupStage.ready,
        isReady: true,
        progress: 1.0,
      );
    } catch (e) {
      state = state.copyWith(
        stage: OllamaSetupStage.error,
        error: e.toString(),
      );
    }
  }

  /// Relance le setup après une erreur.
  void retry() {
    state = const OllamaSetupState();
    _startSetup();
  }
}
