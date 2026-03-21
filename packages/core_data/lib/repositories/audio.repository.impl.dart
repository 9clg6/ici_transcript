import 'package:core_domain/domain/entities/audio_device.entity.dart';
import 'package:core_domain/domain/repositories/audio.repository.dart';

/// Implementation de [AudioRepository] delegant au Platform Channel (Swift).
///
/// Cette classe sert de pont entre la couche data et la couche plateforme.
/// L'implementation reelle de la capture audio est en Swift natif
/// via MethodChannel et EventChannel.
///
/// Les methodes deleguent a un handler de Platform Channel qui sera
/// injecte par la couche app au moment de l'initialisation.
final class AudioRepositoryImpl implements AudioRepository {
  /// Cree une instance de [AudioRepositoryImpl].
  AudioRepositoryImpl({
    required Future<void> Function({
      required String inputDeviceId,
      required String outputDeviceId,
    })
    startCaptureHandler,
    required Future<void> Function() stopCaptureHandler,
    required Stream<AudioChunk> audioStreamHandler,
    required Future<List<AudioDeviceEntity>> Function() listDevicesHandler,
    required Future<bool> Function() isSystemAudioAvailableHandler,
  }) : _startCaptureHandler = startCaptureHandler,
       _stopCaptureHandler = stopCaptureHandler,
       _audioStreamHandler = audioStreamHandler,
       _listDevicesHandler = listDevicesHandler,
       _isSystemAudioAvailableHandler = isSystemAudioAvailableHandler;

  final Future<void> Function({
    required String inputDeviceId,
    required String outputDeviceId,
  })
  _startCaptureHandler;

  final Future<void> Function() _stopCaptureHandler;
  final Stream<AudioChunk> _audioStreamHandler;
  final Future<List<AudioDeviceEntity>> Function() _listDevicesHandler;
  final Future<bool> Function() _isSystemAudioAvailableHandler;

  @override
  Future<void> startCapture({
    required String inputDeviceId,
    required String outputDeviceId,
  }) {
    return _startCaptureHandler(
      inputDeviceId: inputDeviceId,
      outputDeviceId: outputDeviceId,
    );
  }

  @override
  Future<void> stopCapture() {
    return _stopCaptureHandler();
  }

  @override
  Stream<AudioChunk> get audioStream => _audioStreamHandler;

  @override
  Future<List<AudioDeviceEntity>> listDevices() {
    return _listDevicesHandler();
  }

  @override
  Future<bool> isSystemAudioAvailable() {
    return _isSystemAudioAvailableHandler();
  }
}
