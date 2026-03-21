// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription.service.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transcriptionServiceHash() =>
    r'8d205d12e856b9f6bea2bb3928c1f8ecba6a8c48';

/// Provider singleton pour [TranscriptionService].
///
/// Orchestre le cycle de vie d'une session de transcription :
/// demarrage, arret, sauvegarde des segments.
/// Maintient un etat reactif via [BehaviorSubject].
///
/// Copied from [transcriptionService].
@ProviderFor(transcriptionService)
final transcriptionServiceProvider = Provider<TranscriptionService>.internal(
  transcriptionService,
  name: r'transcriptionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transcriptionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TranscriptionServiceRef = ProviderRef<TranscriptionService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
