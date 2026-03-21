// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionListViewModelHash() =>
    r'd4b55e9c10867e43e8168cf2a4e10fb23687b88d';

/// ViewModel de la liste des sessions (sidebar).
///
/// Ecoute le [SessionHistoryService] pour charger et filtrer
/// les sessions, gerer la selection et la suppression.
///
/// Copied from [SessionListViewModel].
@ProviderFor(SessionListViewModel)
final sessionListViewModelProvider =
    AutoDisposeNotifierProvider<
      SessionListViewModel,
      SessionListState
    >.internal(
      SessionListViewModel.new,
      name: r'sessionListViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionListViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SessionListViewModel = AutoDisposeNotifier<SessionListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
