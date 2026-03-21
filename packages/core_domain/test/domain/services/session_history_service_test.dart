import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/audio_source.enum.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/repositories/transcript.repository.dart';
import 'package:core_domain/domain/services/session_history.service.dart';
import 'package:core_domain/domain/usecases/delete_session.use_case.dart';
import 'package:core_domain/domain/usecases/get_session_detail.use_case.dart';
import 'package:core_domain/domain/usecases/get_sessions.use_case.dart';
import 'package:core_domain/domain/usecases/update_session_title.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository, TranscriptRepository])
import 'session_history_service_test.mocks.dart';

void main() {
  /// Tests unitaires pour [SessionHistoryService].
  ///
  /// Verifie l'orchestration du chargement, de la consultation,
  /// de la suppression et de la mise a jour des sessions.
  group('SessionHistoryService', () {
    late MockSessionRepository mockSessionRepository;
    late MockTranscriptRepository mockTranscriptRepository;
    late SessionHistoryService service;

    final List<SessionEntity> testSessions = <SessionEntity>[
      SessionEntity(
        id: 'session-1',
        title: 'Reunion equipe',
        createdAt: DateTime(2026, 3, 19, 10, 0),
        updatedAt: DateTime(2026, 3, 19, 10, 30),
        durationSeconds: 1800,
        status: SessionStatus.completed,
      ),
      SessionEntity(
        id: 'session-2',
        title: 'Call client',
        createdAt: DateTime(2026, 3, 19, 14, 0),
        updatedAt: DateTime(2026, 3, 19, 14, 45),
        durationSeconds: 2700,
        status: SessionStatus.completed,
      ),
    ];

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      mockTranscriptRepository = MockTranscriptRepository();

      final GetSessionsUseCase getSessionsUseCase = GetSessionsUseCase(
        sessionRepository: mockSessionRepository,
      );
      final GetSessionDetailUseCase getSessionDetailUseCase =
          GetSessionDetailUseCase(
            sessionRepository: mockSessionRepository,
            transcriptRepository: mockTranscriptRepository,
          );
      final DeleteSessionUseCase deleteSessionUseCase = DeleteSessionUseCase(
        sessionRepository: mockSessionRepository,
        transcriptRepository: mockTranscriptRepository,
      );
      final UpdateSessionTitleUseCase updateSessionTitleUseCase =
          UpdateSessionTitleUseCase(sessionRepository: mockSessionRepository);

      service = SessionHistoryService(
        getSessionsUseCase: getSessionsUseCase,
        getSessionDetailUseCase: getSessionDetailUseCase,
        deleteSessionUseCase: deleteSessionUseCase,
        updateSessionTitleUseCase: updateSessionTitleUseCase,
      );
    });

    tearDown(() {
      service.dispose();
    });

    group('loadSessions', () {
      test('doit charger les sessions et mettre a jour le stream', () async {
        // Arrange
        when(
          mockSessionRepository.getAll(),
        ).thenAnswer((_) async => testSessions);

        // Act
        await service.loadSessions();

        // Assert
        expect(service.sessionsStream.value, equals(testSessions));
        expect(service.sessionsStream.value.length, equals(2));
      });

      test('ne doit pas modifier le stream en cas d\'echec', () async {
        // Arrange
        when(
          mockSessionRepository.getAll(),
        ).thenThrow(Exception('Erreur chargement'));

        // Act
        await service.loadSessions();

        // Assert
        expect(service.sessionsStream.value, isEmpty);
      });
    });

    group('getSessionDetail', () {
      test('doit retourner le detail de la session', () async {
        // Arrange
        final List<TranscriptSegmentEntity> segments =
            <TranscriptSegmentEntity>[
              TranscriptSegmentEntity(
                id: 'seg-1',
                sessionId: 'session-1',
                source: AudioSource.input,
                text: 'Bonjour a tous',
                timestampMs: 0,
                createdAt: DateTime(2026, 3, 19, 10, 0),
              ),
            ];

        when(
          mockSessionRepository.getById('session-1'),
        ).thenAnswer((_) async => testSessions[0]);
        when(
          mockTranscriptRepository.getBySessionId('session-1'),
        ).thenAnswer((_) async => segments);

        // Act
        final SessionDetailResult? result = await service.getSessionDetail(
          'session-1',
        );

        // Assert
        expect(result, isNotNull);
        expect(result!.session.id, equals('session-1'));
        expect(result.segments.length, equals(1));
      });

      test('doit retourner null en cas d\'echec', () async {
        // Arrange
        when(
          mockSessionRepository.getById('session-inexistante'),
        ).thenAnswer((_) async => null);

        // Act
        final SessionDetailResult? result = await service.getSessionDetail(
          'session-inexistante',
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('deleteSession', () {
      test('doit appeler le use case de suppression', () async {
        // Arrange
        when(
          mockTranscriptRepository.deleteBySessionId('session-1'),
        ).thenAnswer((_) async {});
        when(
          mockSessionRepository.delete('session-1'),
        ).thenAnswer((_) async {});

        // Act
        await service.deleteSession('session-1');

        // Assert
        verify(
          mockTranscriptRepository.deleteBySessionId('session-1'),
        ).called(1);
        verify(mockSessionRepository.delete('session-1')).called(1);
      });

      test(
        'ne doit pas supprimer la session si les segments echouent',
        () async {
          // Arrange
          when(
            mockTranscriptRepository.deleteBySessionId('session-1'),
          ).thenThrow(Exception('Erreur suppression'));

          // Act
          await service.deleteSession('session-1');

          // Assert
          verify(
            mockTranscriptRepository.deleteBySessionId('session-1'),
          ).called(1);
          verifyNever(mockSessionRepository.delete(any));
        },
      );
    });

    group('updateSessionTitle', () {
      test('doit mettre a jour le titre via le repository', () async {
        // Arrange
        final SessionEntity updatedSession = testSessions[0].copyWith(
          title: 'Nouveau titre',
        );

        when(
          mockSessionRepository.getById('session-1'),
        ).thenAnswer((_) async => testSessions[0]);
        when(
          mockSessionRepository.update(any),
        ).thenAnswer((_) async => updatedSession);
        // loadSessions est appele en fire-and-forget apres le succes
        when(
          mockSessionRepository.getAll(),
        ).thenAnswer((_) async => <SessionEntity>[updatedSession]);

        // Act
        await service.updateSessionTitle(
          sessionId: 'session-1',
          newTitle: 'Nouveau titre',
        );

        // Assert
        verify(mockSessionRepository.getById('session-1')).called(1);
        verify(mockSessionRepository.update(any)).called(1);
      });

      test('ne doit pas mettre a jour si session introuvable', () async {
        // Arrange
        when(
          mockSessionRepository.getById('session-1'),
        ).thenAnswer((_) async => null);

        // Act
        await service.updateSessionTitle(
          sessionId: 'session-1',
          newTitle: 'Nouveau titre',
        );

        // Assert
        verify(mockSessionRepository.getById('session-1')).called(1);
        verifyNever(mockSessionRepository.update(any));
      });
    });

    group('dispose', () {
      test('doit fermer le stream des sessions', () {
        // Act
        service.dispose();

        // Assert
        expect(service.sessionsStream.isClosed, isTrue);
      });
    });
  });
}
