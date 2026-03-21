// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$kernelHash() => r'482defeffe9277afae93a00eee75b12229f2d9bd';

/// Initialise les dependances au demarrage de l'application.
///
/// Le serveur ML (voxmlx-serve) est demarre par [LiveTranscriptionService]
/// au moment ou l'utilisateur lance un enregistrement.
/// Ollama est initialise separement par [OllamaSetupViewModel].
///
/// Copied from [kernel].
@ProviderFor(kernel)
final kernelProvider = FutureProvider<void>.internal(
  kernel,
  name: r'kernelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$kernelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef KernelRef = FutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
