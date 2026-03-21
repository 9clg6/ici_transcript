// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_setup.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ollamaSetupViewModelHash() =>
    r'd6465edc20f0c12fbc936beb96c3a55545547186';

/// ViewModel du processus de configuration initiale d'Ollama.
///
/// Surveille et déclenche le téléchargement du binaire Ollama et du modèle
/// Mistral si nécessaire. Appelé une seule fois au démarrage de l'app.
///
/// Copied from [OllamaSetupViewModel].
@ProviderFor(OllamaSetupViewModel)
final ollamaSetupViewModelProvider =
    NotifierProvider<OllamaSetupViewModel, OllamaSetupState>.internal(
      OllamaSetupViewModel.new,
      name: r'ollamaSetupViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ollamaSetupViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OllamaSetupViewModel = Notifier<OllamaSetupState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
