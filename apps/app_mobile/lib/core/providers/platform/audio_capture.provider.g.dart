// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_capture.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioCaptureChannelHash() =>
    r'2a24a25010546af10c0df13d3b83e3c5e78c6f61';

/// Provider singleton pour [AudioCaptureChannel].
///
/// Fournit le pont vers la couche plateforme Swift pour la capture audio
/// (microphone et audio systeme via ScreenCaptureKit).
///
/// Copied from [audioCaptureChannel].
@ProviderFor(audioCaptureChannel)
final audioCaptureChannelProvider = Provider<AudioCaptureChannel>.internal(
  audioCaptureChannel,
  name: r'audioCaptureChannelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioCaptureChannelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AudioCaptureChannelRef = ProviderRef<AudioCaptureChannel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
