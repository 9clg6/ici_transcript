import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_domain/domain/services/transcription.service.dart';
import 'package:core_domain/domain/usecases/save_transcript_segment.use_case.dart';
import 'package:core_domain/domain/usecases/start_session.use_case.dart';
import 'package:core_domain/domain/usecases/stop_session.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository, TranscriptRepository])
import 'transcription_service_test.mocks.dart';

void main() {
  /// Tests unitaires pour [TranscriptionService].
  ///
  /// Verifie l'orchestration du cycle de vie d'une session
  /// de transcription : demarrage, arret, sauvegarde des segments.
  group('TranscriptionService', () {
    late MockSessionRepository mockSessionRepository;
    late MockTranscriptRepository mockTranscriptRepository;
    late TranscriptionService service;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      mockTranscriptRepository = MockTranscriptRepository();

      final StartSessionUseCase startSessionUseCase = StartSessionUseCase(
        sessionRepository: mockSessionRepository,
      );
      final StopSessionUseCase stopSessionUseCase = StopSessionUseCase(
        sessionRepository: mockSessionRepository,
      );
      final SaveTranscriptSegmentUseCase saveTranscriptSegmentUseCase =
          SaveTranscriptSegmentUseCase(
            transcriptRepository: mockTranscriptRepository,
          );

      service = TranscriptionService(
        startSessionUseCase: startSessionUseCase,
        stopSessionUseCase: stopSessionUseCase,
        saveTranscriptSegmentUseCase: saveTranscriptSegmentUseCase,
      );
    });

    tearDown(() {
      service.dispose();
    });

    group('startSession', () {
      test(
        'doit mettre a jour currentSessionStream en cas de succes',
        () async {
          // Arrange
          when(mockSessionRepository.create(any)).thenAnswer(
            (Invocation inv) async =>
                inv.positionalArguments[0] as SessionEntity,
          );

          // Act
          await service.startSession();

          // Assert
          expect(service.currentSessionStream.value, isNotNull);
          expect(
            service.currentSessionStream.value!.status,
            equals(SessionStatus.active),
          );
        },
      );

      test('doit vider segmentsStream au demarrage', () async {
        // Arrange
        when(mockSessionRepository.create(any)).thenAnswer(
          (Invocation inv) async => inv.positionalArguments[0] as SessionEntity,
        );

        // Act
        await service.startSession();

        // Assert
        expect(service.segmentsStream.value, isEmpty);
      });

      test('doit passer isTranscribingStream a true', () async {
        // Arrange
        when(mockSessionRepository.create(any)).thenAnswer(
          (Invocation inv) async => inv.positionalArguments[0] as SessionEntity,
        );

        // Act
        await service.startSession();

        // Assert
        expect(service.isTranscribingStream.value, isTrue);
      });

      test('ne doit pas modifier les streams en cas d\'echec', () async {
        // Arrange
        when(
          mockSessionRepository.create(any),
        ).thenThrow(Exception('Erreur demarrage'));

        // Act
        await service.startSession();

        // Assert
        expect(service.currentSessionStream.value, isNull);
        expect(service.isTranscribingStream.value, isFalse);
      });
    });

    group('stopSession', () {
      test(
        'doit mettre a jour currentSessionStream avec la session completee',
        () async {
          // Arrange : demarrer une session d'abord
          when(mockSessionRepository.create(any)).thenAnswer(
            (Invocation inv) async =>
                inv.positionalArguments[0] as SessionEntity,
          );
          await service.startSession();

          final String sessionId = service.currentSessionStream.value!.id;

          when(
            mockSessionRepository.getById(sessionId),
          ).thenAnswer((_) async => service.currentSessionStream.value);
          when(mockSessionRepository.update(any)).thenAnswer(
            (Invocation inv) async =>
                inv.positionalArguments[0] as SessionEntity,
          );

          // Act
          await service.stopSession();

          // Assert
          expect(
            service.currentSessionStream.value?.status,
            equals(SessionStatus.completed),
          );
        },
      );

      test('doit passer isTranscribingStream a false', () async {
        // Arrange
        when(mockSessionRepository.create(any)).thenAnswer(
          (Invocation inv) async => inv.positionalArguments[0] as SessionEntity,
        );
        await service.startSession();

        final String sessionId = service.currentSessionStream.value!.id;

        when(
          mockSessionRepository.getById(sessionId),
        ).thenAnswer((_) async => service.currentSessionStream.value);
        when(mockSessionRepository.update(any)).thenAnswer(
          (Invocation inv) async => inv.positionalArguments[0] as SessionEntity,
        );

        // Act
        await service.stopSession();

        // Assert
        expect(service.isTranscribingStream.value, isFalse);
      });

      test('ne doit rien faire si aucune session active', () async {
        // Act
        await service.stopSession();

        // Assert
        verifyNever(mockSessionRepository.getById(any));
        verifyNever(mockSessionRepository.update(any));
      });

      test(
        'ne doit rien faire si la session courante n\'est pas active',
        () async {
          // Arrange : simuler une session deja completee
          final SessionEntity completedSession = SessionEntity(
            id: 'session-1',
            title: 'Session 2026-03-19 10:00',
            createdAt: DateTime(2026, 3, 19, 10, 0),
            updatedAt: DateTime(2026, 3, 19, 10, 30),
            durationSeconds: 1800,
            status: SessionStatus.completed,
          );
          service.currentSessionStream.add(completedSession);

          // Act
          await service.stopSession();

          // Assert
          verifyNever(mockSessionRepository.getById(any));
          verifyNever(mockSessionRepository.update(any));
        },
      );
    });

    group('saveSegment', () {
      test('doit ajouter le segment sauvegarde au stream', () async {
        // Arrange
        final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
          id: 'segment-1',
          sessionId: 'session-1',
          source: AudioSource.input,
          text: 'Bonjour',
          timestampMs: 5000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 5),
        );

        when(mockTranscriptRepository.save(any)).thenAnswer(
          (Invocation inv) async =>
              inv.positionalArguments[0] as TranscriptSegmentEntity,
        );

        // Act
        await service.saveSegment(segment);

        // Assert
        expect(service.segmentsStream.value.length, equals(1));
        expect(service.segmentsStream.value.first, equals(segment));
      });

      test('doit accumuler les segments dans le stream', () async {
        // Arrange
        final TranscriptSegmentEntity segment1 = TranscriptSegmentEntity(
          id: 'segment-1',
          sessionId: 'session-1',
          source: AudioSource.input,
          text: 'Bonjour',
          timestampMs: 5000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 5),
        );
        final TranscriptSegmentEntity segment2 = TranscriptSegmentEntity(
          id: 'segment-2',
          sessionId: 'session-1',
          source: AudioSource.output,
          text: 'Salut',
          timestampMs: 8000,
          createdAt: DateTime(2026, 3, 19, 10, 0, 8),
        );

        when(mockTranscriptRepository.save(any)).thenAnswer(
          (Invocation inv) async =>
              inv.positionalArguments[0] as TranscriptSegmentEntity,
        );

        // Act
        await service.saveSegment(segment1);
        await service.saveSegment(segment2);

        // Assert
        expect(service.segmentsStream.value.length, equals(2));
      });

      test('ne doit pas modifier le stream en cas d\'echec', () async {
        // Arrange
        final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
          id: 'segment-err',
          sessionId: 'session-1',
          source: AudioSource.input,
          text: 'Erreur',
          timestampMs: 0,
          createdAt: DateTime(2026, 3, 19),
        );

        when(
          mockTranscriptRepository.save(any),
        ).thenThrow(Exception('Erreur sauvegarde'));

        // Act
        await service.saveSegment(segment);

        // Assert
        expect(service.segmentsStream.value, isEmpty);
      });
    });

    group('dispose', () {
      test('doit fermer tous les streams', () async {
        // Act
        service.dispose();

        // Assert
        expect(service.currentSessionStream.isClosed, isTrue);
        expect(service.segmentsStream.isClosed, isTrue);
        expect(service.isTranscribingStream.isClosed, isTrue);
      });
    });
  });
}
