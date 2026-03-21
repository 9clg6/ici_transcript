import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/params/stop_session.param.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/usecases/stop_session.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository])
import 'stop_session_use_case_test.mocks.dart';

void main() {
  /// Tests unitaires pour [StopSessionUseCase].
  ///
  /// Verifie que le use case met a jour le statut de la session
  /// a 'completed' et calcule la duree correctement.
  group('StopSessionUseCase', () {
    late MockSessionRepository mockSessionRepository;
    late StopSessionUseCase useCase;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      useCase = StopSessionUseCase(sessionRepository: mockSessionRepository);
    });

    test('doit mettre a jour le statut de la session a completed', () async {
      // Arrange
      final SessionEntity existingSession = SessionEntity(
        id: 'session-1',
        title: 'Session test',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: SessionStatus.active,
      );

      when(
        mockSessionRepository.getById('session-1'),
      ).thenAnswer((_) async => existingSession);
      when(mockSessionRepository.update(any)).thenAnswer(
        (Invocation invocation) async =>
            invocation.positionalArguments[0] as SessionEntity,
      );

      // Act
      final SessionEntity result = await useCase.invoke(
        const StopSessionParam(sessionId: 'session-1'),
      );

      // Assert
      expect(result.status, equals(SessionStatus.completed));
    });

    test('doit calculer la duree en secondes', () async {
      // Arrange
      final DateTime createdAt = DateTime.now().subtract(
        const Duration(minutes: 45),
      );
      final SessionEntity existingSession = SessionEntity(
        id: 'session-1',
        title: 'Session test',
        createdAt: createdAt,
        updatedAt: createdAt,
        status: SessionStatus.active,
      );

      when(
        mockSessionRepository.getById('session-1'),
      ).thenAnswer((_) async => existingSession);
      when(mockSessionRepository.update(any)).thenAnswer(
        (Invocation invocation) async =>
            invocation.positionalArguments[0] as SessionEntity,
      );

      // Act
      final SessionEntity result = await useCase.invoke(
        const StopSessionParam(sessionId: 'session-1'),
      );

      // Assert
      expect(result.durationSeconds, isNotNull);
      expect(result.durationSeconds!, greaterThanOrEqualTo(45 * 60 - 1));
    });

    test('doit mettre a jour updatedAt', () async {
      // Arrange
      final DateTime createdAt = DateTime.now().subtract(
        const Duration(hours: 1),
      );
      final SessionEntity existingSession = SessionEntity(
        id: 'session-1',
        title: 'Session test',
        createdAt: createdAt,
        updatedAt: createdAt,
        status: SessionStatus.active,
      );

      when(
        mockSessionRepository.getById('session-1'),
      ).thenAnswer((_) async => existingSession);
      when(mockSessionRepository.update(any)).thenAnswer(
        (Invocation invocation) async =>
            invocation.positionalArguments[0] as SessionEntity,
      );

      // Act
      final SessionEntity result = await useCase.invoke(
        const StopSessionParam(sessionId: 'session-1'),
      );

      // Assert
      expect(result.updatedAt.isAfter(createdAt), isTrue);
    });

    test('doit lever une exception si la session est introuvable', () async {
      // Arrange
      when(
        mockSessionRepository.getById('session-inexistante'),
      ).thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => useCase.invoke(
          const StopSessionParam(sessionId: 'session-inexistante'),
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'doit appeler repository.update avec la session mise a jour',
      () async {
        // Arrange
        final SessionEntity existingSession = SessionEntity(
          id: 'session-1',
          title: 'Session test',
          createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
          status: SessionStatus.active,
        );

        when(
          mockSessionRepository.getById('session-1'),
        ).thenAnswer((_) async => existingSession);
        when(mockSessionRepository.update(any)).thenAnswer(
          (Invocation invocation) async =>
              invocation.positionalArguments[0] as SessionEntity,
        );

        // Act
        await useCase.invoke(const StopSessionParam(sessionId: 'session-1'));

        // Assert
        final SessionEntity captured =
            verify(mockSessionRepository.update(captureAny)).captured.single
                as SessionEntity;
        expect(captured.status, equals(SessionStatus.completed));
        expect(captured.durationSeconds, isNotNull);
      },
    );
  });
}
