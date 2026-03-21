import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ici_transcript/application/services/ollama.service.dart';

part 'ollama_setup.state.freezed.dart';

/// Etat du processus de configuration initiale d'Ollama.
@Freezed(copyWith: true)
abstract class OllamaSetupState with _$OllamaSetupState {
  const factory OllamaSetupState({
    /// Etape courante.
    @Default(OllamaSetupStage.idle) OllamaSetupStage stage,

    /// Progression de l'etape courante (0.0 – 1.0).
    @Default(0.0) double progress,

    /// Ollama est completement pret.
    @Default(false) bool isReady,

    /// Message d'erreur si echec.
    String? error,
  }) = _OllamaSetupState;
}
