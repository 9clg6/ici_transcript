import 'package:core_data/datasources/local/transcript.local.data_source.dart';
import 'package:core_data/model/local/transcript_segment.local.model.dart';
import 'package:core_data/repositories/transcript.repository.impl.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[TranscriptLocalDataSource])
import 'transcript_repository_impl_test.mocks.dart';

void main() {
  /// Tests unitaires pour [TranscriptRepositoryImpl].
  ///
  /// Verifie que le repository mappe correctement les modeles locaux
  /// vers les entites domain et delegue aux datasources.
  group('TranscriptRepositoryImpl', () {
    late MockTranscriptLocalDataSource mockDataSource;
    late TranscriptRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockTranscriptLocalDataSource();
      repository = TranscriptRepositoryImpl(
        transcriptLocalDataSource: mockDataSource,
      );
    });

    group('getBySessionId', () {
      test('doit retourner les segments mappes en entites', () async {
        // Arrange
        final List<TranscriptSegmentLocalModel> localModels =
            <TranscriptSegmentLocalModel>[
              const TranscriptSegmentLocalModel(
                id: 'segment-1',
                sessionId: 'session-1',
                source: 'input',
                text: 'Bonjour',
                timestampMs: 5000,
                createdAt: '2026-03-19T10:00:05.000',
              ),
              const TranscriptSegmentLocalModel(
                id: 'segment-2',
                sessionId: 'session-1',
                source: 'output',
                text: 'Salut',
                timestampMs: 8000,
                createdAt: '2026-03-19T10:00:08.000',
              ),
            ];

        when(
          mockDataSource.getBySessionId('session-1'),
        ).thenAnswer((_) async => localModels);

        // Act
        final List<TranscriptSegmentEntity> result = await repository
            .getBySessionId('session-1');

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('segment-1'));
        expect(result[0].source, equals(AudioSource.input));
        expect(result[0].text, equals('Bonjour'));
        expect(result[1].id, equals('segment-2'));
        expect(result[1].source, equals(AudioSource.output));
        verify(mockDataSource.getBySessionId('session-1')).called(1);
      });

      test('doit retourner une liste vide si aucun segment', () async {
        // Arrange
        when(
          mockDataSource.getBySessionId('session-vide'),
        ).thenAnswer((_) async => <TranscriptSegmentLocalModel>[]);

        // Act
        final List<TranscriptSegmentEntity> result = await repository
            .getBySessionId('session-vide');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('save', () {
      test('doit inserer le model local et retourner l\'entite', () async {
        // Arrange
        final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
          id: 'segment-new',
          sessionId: 'session-1',
          source: AudioSource.input,
          text: 'Nouveau segment',
          timestampMs: 30000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 30),
        );

        when(mockDataSource.insert(any)).thenAnswer((_) async {});

        // Act
        final TranscriptSegmentEntity result = await repository.save(segment);

        // Assert
        expect(result.id, equals('segment-new'));
        expect(result.text, equals('Nouveau segment'));
        verify(mockDataSource.insert(any)).called(1);
      });
    });

    group('saveBatch', () {
      test('doit inserer le lot de modeles et retourner les entites', () async {
        // Arrange
        final List<TranscriptSegmentEntity> segments =
            <TranscriptSegmentEntity>[
              TranscriptSegmentEntity(
                id: 'segment-batch-1',
                sessionId: 'session-1',
                source: AudioSource.input,
                text: 'Premier segment',
                timestampMs: 0,
                createdAt: DateTime(2026, 3, 19, 10, 0),
              ),
              TranscriptSegmentEntity(
                id: 'segment-batch-2',
                sessionId: 'session-1',
                source: AudioSource.output,
                text: 'Deuxieme segment',
                timestampMs: 5000,
                createdAt: DateTime(2026, 3, 19, 10, 0, 5),
              ),
            ];

        when(mockDataSource.insertBatch(any)).thenAnswer((_) async {});

        // Act
        final List<TranscriptSegmentEntity> result = await repository.saveBatch(
          segments,
        );

        // Assert
        expect(result.length, equals(2));
        verify(mockDataSource.insertBatch(any)).called(1);
      });
    });

    group('deleteBySessionId', () {
      test('doit appeler deleteBySessionId sur le datasource', () async {
        // Arrange
        when(
          mockDataSource.deleteBySessionId('session-1'),
        ).thenAnswer((_) async {});

        // Act
        await repository.deleteBySessionId('session-1');

        // Assert
        verify(mockDataSource.deleteBySessionId('session-1')).called(1);
      });
    });
  });
}
