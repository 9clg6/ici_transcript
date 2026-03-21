import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcript_event.remote.model.freezed.dart';
part 'transcript_event.remote.model.g.dart';

/// Modele de donnees distant representant un evenement de transcription
/// recu via WebSocket depuis voxmlx-serve (format OpenAI Realtime API).
///
/// Le serveur voxmlx-serve envoie :
/// - `response.audio_transcript.delta` avec un champ `delta`
/// - `response.audio_transcript.done` avec un champ `text` (pas `transcript`)
@freezed
abstract class TranscriptEventRemoteModel with _$TranscriptEventRemoteModel {
  /// Cree une instance de [TranscriptEventRemoteModel].
  const factory TranscriptEventRemoteModel({
    /// Type d'evenement (ex: 'response.audio_transcript.delta').
    required String type,

    /// Delta de transcription incrementale.
    String? delta,

    /// Transcription complete du segment (champ `text` de voxmlx-serve).
    String? text,
  }) = _TranscriptEventRemoteModel;

  /// Cree une instance depuis un JSON.
  factory TranscriptEventRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TranscriptEventRemoteModelFromJson(json);
}
