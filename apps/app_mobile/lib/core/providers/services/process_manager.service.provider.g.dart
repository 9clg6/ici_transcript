// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_manager.service.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$processManagerServiceHash() =>
    r'd7be5c19b5f27573d6b7412dcaa386a983e4ea46';

/// Provider singleton pour [ProcessManagerService].
///
/// Wrape le [ProcessManagerChannel] pour fournir une API
/// de plus haut niveau pour le cycle de vie du serveur ML.
///
/// Copied from [processManagerService].
@ProviderFor(processManagerService)
final processManagerServiceProvider = Provider<ProcessManagerService>.internal(
  processManagerService,
  name: r'processManagerServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$processManagerServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessManagerServiceRef = ProviderRef<ProcessManagerService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
