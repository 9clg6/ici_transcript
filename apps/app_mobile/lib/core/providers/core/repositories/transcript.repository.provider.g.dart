// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript.repository.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transcriptRepositoryHash() =>
    r'bb453fc13dbb43577c882912015a1897b02cd295';

/// Provider pour [TranscriptRepository].
///
/// Fournit l'implementation [TranscriptRepositoryImpl] qui utilise
/// la source de donnees locale Drift pour la persistance des segments.
///
/// Copied from [transcriptRepository].
@ProviderFor(transcriptRepository)
final transcriptRepositoryProvider =
    AutoDisposeProvider<TranscriptRepository>.internal(
      transcriptRepository,
      name: r'transcriptRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transcriptRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TranscriptRepositoryRef = AutoDisposeProviderRef<TranscriptRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
