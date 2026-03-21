// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.local.data_source.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionLocalDataSourceHash() =>
    r'a5afd34b2eec1abf4f85b32fc03b4e5d065a2d9a';

/// Provider pour [SessionLocalDataSource].
///
/// Fournit l'implementation basee sur Drift/SQLite pour la persistance
/// des sessions de transcription.
///
/// Copied from [sessionLocalDataSource].
@ProviderFor(sessionLocalDataSource)
final sessionLocalDataSourceProvider =
    AutoDisposeProvider<SessionLocalDataSource>.internal(
      sessionLocalDataSource,
      name: r'sessionLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionLocalDataSourceRef =
    AutoDisposeProviderRef<SessionLocalDataSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
