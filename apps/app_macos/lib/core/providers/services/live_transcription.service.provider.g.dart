// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_transcription.service.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveTranscriptionServiceHash() =>
    r'd7f9c5e5bc10092b62f6258a586b3bc1a5e0129c';

/// Provider singleton pour [LiveTranscriptionService].
///
/// Orchestre la transcription en direct en coordonnant :
/// - Le serveur ML via [ProcessManagerService]
/// - La capture audio via [AudioCaptureChannel]
/// - Le WebSocket via [TranscriptionRemoteDataSource]
/// - La session et les segments via [TranscriptionService]
///
/// Copied from [liveTranscriptionService].
@ProviderFor(liveTranscriptionService)
final liveTranscriptionServiceProvider =
    Provider<LiveTranscriptionService>.internal(
      liveTranscriptionService,
      name: r'liveTranscriptionServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveTranscriptionServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LiveTranscriptionServiceRef = ProviderRef<LiveTranscriptionService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
