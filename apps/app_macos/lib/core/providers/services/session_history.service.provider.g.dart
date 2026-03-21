// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_history.service.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionHistoryServiceHash() =>
    r'c53afc860b151b9b19b722e4717b6153c3f4b493';

/// Provider pour [SessionHistoryService].
///
/// Orchestre l'historique des sessions : chargement de la liste,
/// detail d'une session, suppression, modification du titre.
///
/// Copied from [sessionHistoryService].
@ProviderFor(sessionHistoryService)
final sessionHistoryServiceProvider =
    AutoDisposeProvider<SessionHistoryService>.internal(
      sessionHistoryService,
      name: r'sessionHistoryServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionHistoryServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SessionHistoryServiceRef =
    AutoDisposeProviderRef<SessionHistoryService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
