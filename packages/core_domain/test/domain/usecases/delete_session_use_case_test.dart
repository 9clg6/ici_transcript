import 'package:core_domain/domain/params/delete_session.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_domain/domain/usecases/delete_session.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository, TranscriptRepository])
import 'delete_session_use_case_test.mocks.dart';

void main() {
  /// Tests unitaires pour [DeleteSessionUseCase].
  ///
  /// Verifie que le use case supprime la session et ses segments
  /// de transcription associes dans le bon ordre.
  group('DeleteSessionUseCase', () {
    late MockSessionRepository mockSessionRepository;
    late MockTranscriptRepository mockTranscriptRepository;
    late DeleteSessionUseCase useCase;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      mockTranscriptRepository = MockTranscriptRepository();
      useCase = DeleteSessionUseCase(
        sessionRepository: mockSessionRepository,
        transcriptRepository: mockTranscriptRepository,
      );
    });

    test('doit supprimer les segments puis la session', () async {
      // Arrange
      const String sessionId = 'session-1';
      when(
        mockTranscriptRepository.deleteBySessionId(sessionId),
      ).thenAnswer((_) async {});
      when(mockSessionRepository.delete(sessionId)).thenAnswer((_) async {});

      // Act
      await useCase.invoke(const DeleteSessionParam(sessionId: sessionId));

      // Assert
      verifyInOrder(<dynamic>[
        mockTranscriptRepository.deleteBySessionId(sessionId),
        mockSessionRepository.delete(sessionId),
      ]);
    });

    test(
      'doit appeler deleteBySessionId sur le transcript repository',
      () async {
        // Arrange
        const String sessionId = 'session-42';
        when(
          mockTranscriptRepository.deleteBySessionId(sessionId),
        ).thenAnswer((_) async {});
        when(mockSessionRepository.delete(sessionId)).thenAnswer((_) async {});

        // Act
        await useCase.invoke(const DeleteSessionParam(sessionId: sessionId));

        // Assert
        verify(mockTranscriptRepository.deleteBySessionId(sessionId)).called(1);
      },
    );

    test('doit appeler delete sur le session repository', () async {
      // Arrange
      const String sessionId = 'session-42';
      when(
        mockTranscriptRepository.deleteBySessionId(sessionId),
      ).thenAnswer((_) async {});
      when(mockSessionRepository.delete(sessionId)).thenAnswer((_) async {});

      // Act
      await useCase.invoke(const DeleteSessionParam(sessionId: sessionId));

      // Assert
      verify(mockSessionRepository.delete(sessionId)).called(1);
    });

    test(
      'doit propager l\'exception si la suppression des segments echoue',
      () async {
        // Arrange
        const String sessionId = 'session-1';
        when(
          mockTranscriptRepository.deleteBySessionId(sessionId),
        ).thenThrow(Exception('Erreur suppression segments'));

        // Act & Assert
        expect(
          () => useCase.invoke(const DeleteSessionParam(sessionId: sessionId)),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockSessionRepository.delete(any));
      },
    );
  });
}
