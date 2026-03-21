import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_device.entity.freezed.dart';

/// Entite representant un peripherique audio.
@freezed
abstract class AudioDeviceEntity with _$AudioDeviceEntity {
  /// Cree une instance de [AudioDeviceEntity].
  const factory AudioDeviceEntity({
    /// Identifiant unique du peripherique.
    required String id,

    /// Nom du peripherique audio.
    required String name,

    /// Indique si le peripherique est un input (micro).
    required bool isInput,
  }) = _AudioDeviceEntity;
}
