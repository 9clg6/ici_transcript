import 'dart:typed_data';

import 'package:core_domain/domain/entities/audio_device.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';

/// Chunk audio brut avec sa source.
class AudioChunk {
  /// Cree une instance de [AudioChunk].
  const AudioChunk({required this.source, required this.data});

  /// Source audio (micro ou systeme).
  final AudioSource source;

  /// Donnees audio brutes (PCM float32, 16kHz).
  final Uint8List data;
}

/// Contrat du repository de capture audio.
abstract interface class AudioRepository {
  /// Demarre la capture audio.
  Future<void> startCapture({
    required String inputDeviceId,
    required String outputDeviceId,
  });

  /// Arrete la capture audio.
  Future<void> stopCapture();

  /// Stream des chunks audio bruts.
  Stream<AudioChunk> get audioStream;

  /// Liste les peripheriques audio disponibles.
  Future<List<AudioDeviceEntity>> listDevices();

  /// Indique si la capture audio systeme est disponible.
  Future<bool> isSystemAudioAvailable();
}
