// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript.local.data_source.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transcriptLocalDataSourceHash() =>
    r'f1632fdb34c010f3ac34c04255646e9baa317eb4';

/// Provider pour [TranscriptLocalDataSource].
///
/// Fournit l'implementation basee sur Drift/SQLite pour la persistance
/// des segments de transcription.
///
/// Copied from [transcriptLocalDataSource].
@ProviderFor(transcriptLocalDataSource)
final transcriptLocalDataSourceProvider =
    AutoDisposeProvider<TranscriptLocalDataSource>.internal(
      transcriptLocalDataSource,
      name: r'transcriptLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transcriptLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TranscriptLocalDataSourceRef =
    AutoDisposeProviderRef<TranscriptLocalDataSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
