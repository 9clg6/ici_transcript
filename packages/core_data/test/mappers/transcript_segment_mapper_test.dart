import 'package:core_data/mappers/transcript_segment.mapper.dart';
import 'package:core_data/model/local/transcript_segment.local.model.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:test/test.dart';

void main() {
  /// Tests unitaires pour les mappers de segment de transcription.
  ///
  /// Verifie la conversion bidirectionnelle entre
  /// [TranscriptSegmentLocalModel] et [TranscriptSegmentEntity].
  group('TranscriptSegmentMapper', () {
    group('TranscriptSegmentLocalModelX.toEntity()', () {
      test('doit convertir un model local en entite avec source input', () {
        // Arrange
        const TranscriptSegmentLocalModel model = TranscriptSegmentLocalModel(
          id: 'segment-1',
          sessionId: 'session-1',
          source: 'input',
          text: 'Bonjour, comment ca va ?',
          timestampMs: 5000,
          createdAt: '2026-03-19T10:00:05.000',
        );

        // Act
        final TranscriptSegmentEntity entity = model.toEntity();

        // Assert
        expect(entity.id, equals('segment-1'));
        expect(entity.sessionId, equals('session-1'));
        expect(entity.source, equals(AudioSource.input));
        expect(entity.text, equals('Bonjour, comment ca va ?'));
        expect(entity.timestampMs, equals(5000));
        expect(entity.createdAt, equals(DateTime(2026, 3, 19, 10, 0, 5)));
      });

      test('doit convertir un model local en entite avec source output', () {
        // Arrange
        const TranscriptSegmentLocalModel model = TranscriptSegmentLocalModel(
          id: 'segment-2',
          sessionId: 'session-1',
          source: 'output',
          text: 'Oui, j\'ai prepare les documents.',
          timestampMs: 12000,
          createdAt: '2026-03-19T10:00:12.000',
        );

        // Act
        final TranscriptSegmentEntity entity = model.toEntity();

        // Assert
        expect(entity.source, equals(AudioSource.output));
        expect(entity.text, equals('Oui, j\'ai prepare les documents.'));
      });
    });

    group('TranscriptSegmentEntityToLocalX.toLocalModel()', () {
      test('doit convertir une entite en model local', () {
        // Arrange
        final TranscriptSegmentEntity entity = TranscriptSegmentEntity(
          id: 'segment-1',
          sessionId: 'session-1',
          source: AudioSource.input,
          text: 'Bonjour, comment ca va ?',
          timestampMs: 5000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 5),
        );

        // Act
        final TranscriptSegmentLocalModel model = entity.toLocalModel();

        // Assert
        expect(model.id, equals('segment-1'));
        expect(model.sessionId, equals('session-1'));
        expect(model.source, equals('input'));
        expect(model.text, equals('Bonjour, comment ca va ?'));
        expect(model.timestampMs, equals(5000));
        expect(model.createdAt, contains('2026-03-19'));
      });

      test('doit mapper la source output comme string', () {
        // Arrange
        final TranscriptSegmentEntity entity = TranscriptSegmentEntity(
          id: 'segment-2',
          sessionId: 'session-1',
          source: AudioSource.output,
          text: 'Test output',
          timestampMs: 8000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 8),
        );

        // Act
        final TranscriptSegmentLocalModel model = entity.toLocalModel();

        // Assert
        expect(model.source, equals('output'));
      });
    });

    group('Roundtrip', () {
      test(
        'doit preserver les donnees lors d\'un aller-retour entity->model->entity',
        () {
          // Arrange
          final TranscriptSegmentEntity original = TranscriptSegmentEntity(
            id: 'segment-roundtrip',
            sessionId: 'session-1',
            source: AudioSource.input,
            text: 'Test roundtrip de segment',
            timestampMs: 15000,
            createdAt: DateTime(2026, 3, 19, 10, 0, 15),
          );

          // Act
          final TranscriptSegmentLocalModel model = original.toLocalModel();
          final TranscriptSegmentEntity restored = model.toEntity();

          // Assert
          expect(restored.id, equals(original.id));
          expect(restored.sessionId, equals(original.sessionId));
          expect(restored.source, equals(original.source));
          expect(restored.text, equals(original.text));
          expect(restored.timestampMs, equals(original.timestampMs));
          expect(restored.createdAt, equals(original.createdAt));
        },
      );

      test(
        'doit preserver les donnees lors d\'un aller-retour model->entity->model',
        () {
          // Arrange
          const TranscriptSegmentLocalModel original =
              TranscriptSegmentLocalModel(
                id: 'segment-roundtrip-2',
                sessionId: 'session-2',
                source: 'output',
                text: 'Test roundtrip model',
                timestampMs: 20000,
                createdAt: '2026-03-19T10:00:20.000',
              );

          // Act
          final TranscriptSegmentEntity entity = original.toEntity();
          final TranscriptSegmentLocalModel restored = entity.toLocalModel();

          // Assert
          expect(restored.id, equals(original.id));
          expect(restored.sessionId, equals(original.sessionId));
          expect(restored.source, equals(original.source));
          expect(restored.text, equals(original.text));
          expect(restored.timestampMs, equals(original.timestampMs));
        },
      );
    });
  });
}
