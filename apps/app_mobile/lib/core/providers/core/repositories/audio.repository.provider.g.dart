// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.repository.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioRepositoryHash() => r'12ed54af842ee9efa6bdbc7cfaef4c04832e0dde';

/// Provider pour [AudioRepository].
///
/// Fournit l'implementation [AudioRepositoryImpl] qui delegue les appels
/// au [AudioCaptureChannel] (Platform Channel Swift) pour la capture audio.
///
/// Copied from [audioRepository].
@ProviderFor(audioRepository)
final audioRepositoryProvider = AutoDisposeProvider<AudioRepository>.internal(
  audioRepository,
  name: r'audioRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AudioRepositoryRef = AutoDisposeProviderRef<AudioRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
