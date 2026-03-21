// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription.remote.data_source.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transcriptionRemoteDataSourceHash() =>
    r'815e1836ab5a0d74df09d9cc74a2c120e82d2b21';

/// Provider pour [TranscriptionRemoteDataSource].
///
/// Fournit l'implementation WebSocket pour la communication
/// avec le serveur voxmlx-serve (transcription en temps reel).
///
/// Copied from [transcriptionRemoteDataSource].
@ProviderFor(transcriptionRemoteDataSource)
final transcriptionRemoteDataSourceProvider =
    AutoDisposeProvider<TranscriptionRemoteDataSource>.internal(
      transcriptionRemoteDataSource,
      name: r'transcriptionRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transcriptionRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TranscriptionRemoteDataSourceRef =
    AutoDisposeProviderRef<TranscriptionRemoteDataSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
