import 'package:core_data/mappers/transcript_event.mapper.dart';
import 'package:core_data/model/remote/transcript_event.remote.model.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:test/test.dart';

void main() {
  /// Tests unitaires pour les mappers d'evenement de transcription.
  ///
  /// Verifie le mapping partiel de [TranscriptEventRemoteModel]
  /// vers [TranscriptSegmentEntity] et les helpers isDelta/isComplete.
  group('TranscriptEventMapper', () {
    group('TranscriptEventRemoteModelX.toEntity()', () {
      test('doit mapper un evenement delta avec le texte delta', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.delta',
          delta: 'Bonjour',
        );

        // Act
        final TranscriptSegmentEntity entity = event.toEntity(
          id: 'segment-1',
          sessionId: 'session-1',
          source: AudioSource.input,
          timestampMs: 5000,
        );

        // Assert
        expect(entity.id, equals('segment-1'));
        expect(entity.sessionId, equals('session-1'));
        expect(entity.source, equals(AudioSource.input));
        expect(entity.text, equals('Bonjour'));
        expect(entity.timestampMs, equals(5000));
      });

      test('doit mapper un evenement complete avec le champ text', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.done',
          text: 'Bonjour, comment allez-vous ?',
        );

        // Act
        final TranscriptSegmentEntity entity = event.toEntity(
          id: 'segment-2',
          sessionId: 'session-1',
          source: AudioSource.output,
          timestampMs: 10000,
        );

        // Assert
        expect(entity.text, equals('Bonjour, comment allez-vous ?'));
        expect(entity.source, equals(AudioSource.output));
      });

      test('doit privilegier text sur delta quand les deux sont presents', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.done',
          delta: 'partiel',
          text: 'Texte complet de la transcription',
        );

        // Act
        final TranscriptSegmentEntity entity = event.toEntity(
          id: 'segment-3',
          sessionId: 'session-1',
          source: AudioSource.input,
          timestampMs: 15000,
        );

        // Assert
        expect(entity.text, equals('Texte complet de la transcription'));
      });

      test('doit retourner un texte vide si aucun champ renseigne', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.delta',
        );

        // Act
        final TranscriptSegmentEntity entity = event.toEntity(
          id: 'segment-4',
          sessionId: 'session-1',
          source: AudioSource.input,
          timestampMs: 0,
        );

        // Assert
        expect(entity.text, isEmpty);
      });

      test('doit definir createdAt au moment du mapping', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.delta',
          delta: 'Test',
        );
        final DateTime before = DateTime.now();

        // Act
        final TranscriptSegmentEntity entity = event.toEntity(
          id: 'segment-5',
          sessionId: 'session-1',
          source: AudioSource.input,
          timestampMs: 0,
        );
        final DateTime after = DateTime.now();

        // Assert
        expect(
          entity.createdAt.isAfter(before) ||
              entity.createdAt.isAtSameMomentAs(before),
          isTrue,
        );
        expect(
          entity.createdAt.isBefore(after) ||
              entity.createdAt.isAtSameMomentAs(after),
          isTrue,
        );
      });
    });

    group('isDelta', () {
      test('doit retourner true pour un evenement delta', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.delta',
          delta: 'test',
        );

        // Assert
        expect(event.isDelta, isTrue);
      });

      test('doit retourner false pour un evenement non-delta', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.done',
          text: 'test',
        );

        // Assert
        expect(event.isDelta, isFalse);
      });
    });

    group('isComplete', () {
      test('doit retourner true pour un evenement done', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.done',
          text: 'test complet',
        );

        // Assert
        expect(event.isComplete, isTrue);
      });

      test('doit retourner false pour un evenement non-done', () {
        // Arrange
        const TranscriptEventRemoteModel event = TranscriptEventRemoteModel(
          type: 'response.audio_transcript.delta',
          delta: 'test',
        );

        // Assert
        expect(event.isComplete, isFalse);
      });
    });
  });
}
