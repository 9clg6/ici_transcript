import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';

import 'package:core_data/model/remote/transcript_event.remote.model.dart';

/// Extensions de mapping pour [TranscriptEventRemoteModel].
///
/// Le mapping vers [TranscriptSegmentEntity] est partiel : il necessite
/// l'injection du [sessionId] et de la [source] depuis le contexte appelant.
extension TranscriptEventRemoteModelX on TranscriptEventRemoteModel {
  /// Convertit en [TranscriptSegmentEntity] partiel.
  ///
  /// Necessite les parametres [id], [sessionId], [source] et [timestampMs]
  /// qui ne sont pas fournis par l'evenement WebSocket.
  TranscriptSegmentEntity toEntity({
    required String id,
    required String sessionId,
    required AudioSource source,
    required int timestampMs,
  }) => TranscriptSegmentEntity(
    id: id,
    sessionId: sessionId,
    source: source,
    text: text ?? delta ?? '',
    timestampMs: timestampMs,
    createdAt: DateTime.now(),
  );

  /// Indique si l'evenement contient un delta de transcription.
  bool get isDelta => type == 'response.audio_transcript.delta';

  /// Indique si l'evenement contient une transcription complete.
  bool get isComplete => type == 'response.audio_transcript.done';
}
