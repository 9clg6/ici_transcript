// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionListViewModelHash() =>
    r'846ef91c29c69e4c34afd931f9fe264621e7ed31';

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
