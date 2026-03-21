// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uvx_available.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uvxAvailableHash() => r'bd58ab4819e2d3da8486c474b165ad0d75eea86a';

/// Vérifie si `uvx` est disponible sur le PATH au démarrage.
///
/// Utilisé pour décider d'afficher ou non l'écran d'onboarding.
///
/// Copied from [uvxAvailable].
@ProviderFor(uvxAvailable)
final uvxAvailableProvider = FutureProvider<bool>.internal(
  uvxAvailable,
  name: r'uvxAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uvxAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UvxAvailableRef = FutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
