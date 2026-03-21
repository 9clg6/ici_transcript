// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_detail.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionDetailViewModelHash() =>
    r'4756c77436d1503d0ae325ea1941a426173ade9d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SessionDetailViewModel
    extends BuildlessAutoDisposeAsyncNotifier<SessionDetailState> {
  late final String sessionId;

  FutureOr<SessionDetailState> build({required String sessionId});
}

/// ViewModel de l'ecran de detail d'une session.
///
/// Charge la session et ses segments, gere l'edition du titre,
/// la suppression, l'export et la copie du contenu.
///
/// Copied from [SessionDetailViewModel].
@ProviderFor(SessionDetailViewModel)
const sessionDetailViewModelProvider = SessionDetailViewModelFamily();

/// ViewModel de l'ecran de detail d'une session.
///
/// Charge la session et ses segments, gere l'edition du titre,
/// la suppression, l'export et la copie du contenu.
///
/// Copied from [SessionDetailViewModel].
class SessionDetailViewModelFamily
    extends Family<AsyncValue<SessionDetailState>> {
  /// ViewModel de l'ecran de detail d'une session.
  ///
  /// Charge la session et ses segments, gere l'edition du titre,
  /// la suppression, l'export et la copie du contenu.
  ///
  /// Copied from [SessionDetailViewModel].
  const SessionDetailViewModelFamily();

  /// ViewModel de l'ecran de detail d'une session.
  ///
  /// Charge la session et ses segments, gere l'edition du titre,
  /// la suppression, l'export et la copie du contenu.
  ///
  /// Copied from [SessionDetailViewModel].
  SessionDetailViewModelProvider call({required String sessionId}) {
    return SessionDetailViewModelProvider(sessionId: sessionId);
  }

  @override
  SessionDetailViewModelProvider getProviderOverride(
    covariant SessionDetailViewModelProvider provider,
  ) {
    return call(sessionId: provider.sessionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sessionDetailViewModelProvider';
}

/// ViewModel de l'ecran de detail d'une session.
///
/// Charge la session et ses segments, gere l'edition du titre,
/// la suppression, l'export et la copie du contenu.
///
/// Copied from [SessionDetailViewModel].
class SessionDetailViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SessionDetailViewModel,
          SessionDetailState
        > {
  /// ViewModel de l'ecran de detail d'une session.
  ///
  /// Charge la session et ses segments, gere l'edition du titre,
  /// la suppression, l'export et la copie du contenu.
  ///
  /// Copied from [SessionDetailViewModel].
  SessionDetailViewModelProvider({required String sessionId})
    : this._internal(
        () => SessionDetailViewModel()..sessionId = sessionId,
        from: sessionDetailViewModelProvider,
        name: r'sessionDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sessionDetailViewModelHash,
        dependencies: SessionDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            SessionDetailViewModelFamily._allTransitiveDependencies,
        sessionId: sessionId,
      );

  SessionDetailViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  FutureOr<SessionDetailState> runNotifierBuild(
    covariant SessionDetailViewModel notifier,
  ) {
    return notifier.build(sessionId: sessionId);
  }

  @override
  Override overrideWith(SessionDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SessionDetailViewModelProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    SessionDetailViewModel,
    SessionDetailState
  >
  createElement() {
    return _SessionDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionDetailViewModelProvider &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionDetailViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<SessionDetailState> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _SessionDetailViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SessionDetailViewModel,
          SessionDetailState
        >
    with SessionDetailViewModelRef {
  _SessionDetailViewModelProviderElement(super.provider);

  @override
  String get sessionId => (origin as SessionDetailViewModelProvider).sessionId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
