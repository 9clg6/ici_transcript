import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_domain/domain/usecases/save_transcript_segment.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[TranscriptRepository])
import 'save_transcript_segment_use_case_test.mocks.dart';

void main() {
  /// Tests unitaires pour [SaveTranscriptSegmentUseCase].
  ///
  /// Verifie que le use case sauvegarde correctement un segment
  /// de transcription via le repository.
  group('SaveTranscriptSegmentUseCase', () {
    late MockTranscriptRepository mockTranscriptRepository;
    late SaveTranscriptSegmentUseCase useCase;

    setUp(() {
      mockTranscriptRepository = MockTranscriptRepository();
      useCase = SaveTranscriptSegmentUseCase(
        transcriptRepository: mockTranscriptRepository,
      );
    });

    test('doit sauvegarder un segment via le repository', () async {
      // Arrange
      final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
        id: 'segment-1',
        sessionId: 'session-1',
        source: AudioSource.input,
        text: 'Bonjour, comment ca va ?',
        timestampMs: 5000,
        createdAt: DateTime(2026, 3, 19, 10, 0, 5),
      );

      when(mockTranscriptRepository.save(any)).thenAnswer((_) async => segment);

      // Act
      final TranscriptSegmentEntity result = await useCase.invoke(segment);

      // Assert
      expect(result, equals(segment));
      verify(mockTranscriptRepository.save(segment)).called(1);
    });

    test('doit sauvegarder un segment de source output', () async {
      // Arrange
      final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
        id: 'segment-2',
        sessionId: 'session-1',
        source: AudioSource.output,
        text: 'Oui, j\'ai prepare les documents.',
        timestampMs: 12000,
        createdAt: DateTime(2026, 3, 19, 10, 0, 12),
      );

      when(mockTranscriptRepository.save(any)).thenAnswer((_) async => segment);

      // Act
      final TranscriptSegmentEntity result = await useCase.invoke(segment);

      // Assert
      expect(result.source, equals(AudioSource.output));
      expect(result.text, equals('Oui, j\'ai prepare les documents.'));
    });

    test('doit propager les exceptions du repository', () async {
      // Arrange
      final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
        id: 'segment-err',
        sessionId: 'session-1',
        source: AudioSource.input,
        text: 'Test erreur',
        timestampMs: 0,
        createdAt: DateTime(2026, 3, 19),
      );

      when(
        mockTranscriptRepository.save(any),
      ).thenThrow(Exception('Erreur ecriture'));

      // Act & Assert
      expect(() => useCase.invoke(segment), throwsA(isA<Exception>()));
    });

    test('doit passer le segment exact au repository', () async {
      // Arrange
      final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
        id: 'segment-check',
        sessionId: 'session-99',
        source: AudioSource.input,
        text: 'Verification du passage des parametres',
        timestampMs: 30000,
        createdAt: DateTime(2026, 3, 19, 10, 0, 30),
      );

      when(mockTranscriptRepository.save(any)).thenAnswer((_) async => segment);

      // Act
      await useCase.invoke(segment);

      // Assert
      final TranscriptSegmentEntity captured =
          verify(mockTranscriptRepository.save(captureAny)).captured.single
              as TranscriptSegmentEntity;
      expect(captured.id, equals('segment-check'));
      expect(captured.sessionId, equals('session-99'));
      expect(captured.timestampMs, equals(30000));
    });
  });
}
