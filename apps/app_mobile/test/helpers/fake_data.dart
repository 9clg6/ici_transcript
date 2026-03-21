import 'package:core_domain/domain/entities/audio_device.entity.dart';
import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/summary.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';

/// Fabrique de donnees de test pour les entites du domaine.
///
/// Fournit des methodes statiques pour creer des instances
/// d'entites avec des valeurs par defaut coherentes.
class FakeData {
  FakeData._();

  /// Cree une [SessionEntity] de test.
  static SessionEntity createSession({
    String id = 'session-1',
    String title = 'Session de test',
    DateTime? createdAt,
    DateTime? updatedAt,
    int? durationSeconds,
    SessionStatus status = SessionStatus.active,
  }) {
    final DateTime now = DateTime(2026, 3, 19, 10, 0, 0);
    return SessionEntity(
      id: id,
      title: title,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      durationSeconds: durationSeconds,
      status: status,
    );
  }

  /// Cree une liste de [SessionEntity] de test.
  static List<SessionEntity> createSessionList({int count = 3}) {
    return List<SessionEntity>.generate(
      count,
      (int index) => createSession(
        id: 'session-$index',
        title: 'Session #$index',
        createdAt: DateTime(2026, 3, 19, 10 + index, 0, 0),
        updatedAt: DateTime(2026, 3, 19, 10 + index, 30, 0),
        durationSeconds: 1800 + (index * 600),
        status: index == 0 ? SessionStatus.active : SessionStatus.completed,
      ),
    );
  }

  /// Cree un [TranscriptSegmentEntity] de test.
  static TranscriptSegmentEntity createSegment({
    String id = 'segment-1',
    String sessionId = 'session-1',
    AudioSource source = AudioSource.input,
    String text = 'Bonjour, ceci est un test de transcription.',
    int timestampMs = 0,
    DateTime? createdAt,
  }) {
    return TranscriptSegmentEntity(
      id: id,
      sessionId: sessionId,
      source: source,
      text: text,
      timestampMs: timestampMs,
      createdAt: createdAt ?? DateTime(2026, 3, 19, 10, 0, 0),
    );
  }

  /// Cree une liste de [TranscriptSegmentEntity] de test.
  static List<TranscriptSegmentEntity> createSegmentList({
    String sessionId = 'session-1',
    int count = 5,
  }) {
    return List<TranscriptSegmentEntity>.generate(
      count,
      (int index) => createSegment(
        id: 'segment-$index',
        sessionId: sessionId,
        source: index.isEven ? AudioSource.input : AudioSource.output,
        text: 'Segment de transcription numero $index.',
        timestampMs: index * 5000,
        createdAt: DateTime(2026, 3, 19, 10, 0, index * 5),
      ),
    );
  }

  /// Cree un [AudioDeviceEntity] de test.
  static AudioDeviceEntity createAudioDevice({
    String id = 'device-1',
    String name = 'MacBook Pro Microphone',
    bool isInput = true,
  }) {
    return AudioDeviceEntity(id: id, name: name, isInput: isInput);
  }

  /// Cree une liste de [AudioDeviceEntity] de test.
  static List<AudioDeviceEntity> createAudioDeviceList() {
    return <AudioDeviceEntity>[
      createAudioDevice(
        id: 'mic-1',
        name: 'MacBook Pro Microphone',
        isInput: true,
      ),
      createAudioDevice(id: 'mic-2', name: 'AirPods Pro', isInput: true),
      createAudioDevice(
        id: 'output-1',
        name: 'ScreenCaptureKit',
        isInput: false,
      ),
    ];
  }

  /// Cree un [SummaryEntity] de test.
  static SummaryEntity createSummary({
    String id = 'summary-1',
    String sessionId = 'session-1',
    String content = 'Resume de la session de test.',
    String model = 'mistral-7b',
    DateTime? createdAt,
  }) {
    return SummaryEntity(
      id: id,
      sessionId: sessionId,
      content: content,
      model: model,
      createdAt: createdAt ?? DateTime(2026, 3, 19, 11, 0, 0),
    );
  }

  /// Cree une [SessionEntity] avec le statut 'completed'.
  static SessionEntity createCompletedSession({
    String id = 'session-completed',
    String title = 'Session terminee',
  }) {
    return createSession(
      id: id,
      title: title,
      status: SessionStatus.completed,
      durationSeconds: 3600,
      createdAt: DateTime(2026, 3, 19, 9, 0, 0),
      updatedAt: DateTime(2026, 3, 19, 10, 0, 0),
    );
  }
}
