import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/usecases/start_session.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository])
import 'start_session_use_case_test.mocks.dart';

void main() {
  /// Tests unitaires pour [StartSessionUseCase].
  ///
  /// Verifie que le use case cree correctement une session
  /// avec le statut 'active' via le repository.
  group('StartSessionUseCase', () {
    late MockSessionRepository mockSessionRepository;
    late StartSessionUseCase useCase;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      useCase = StartSessionUseCase(sessionRepository: mockSessionRepository);
    });

    test('doit creer une session avec le statut active', () async {
      // Arrange
      when(mockSessionRepository.create(any)).thenAnswer((
        Invocation invocation,
      ) async {
        final SessionEntity session =
            invocation.positionalArguments[0] as SessionEntity;
        return session;
      });

      // Act
      final SessionEntity result = await useCase.invoke();

      // Assert
      expect(result.status, equals(SessionStatus.active));
      verify(mockSessionRepository.create(any)).called(1);
    });

    test('doit generer un identifiant unique base sur le timestamp', () async {
      // Arrange
      when(mockSessionRepository.create(any)).thenAnswer((
        Invocation invocation,
      ) async {
        final SessionEntity session =
            invocation.positionalArguments[0] as SessionEntity;
        return session;
      });

      // Act
      final SessionEntity result = await useCase.invoke();

      // Assert
      expect(result.id, isNotEmpty);
      expect(int.tryParse(result.id), isNotNull);
    });

    test('doit generer un titre avec la date formatee', () async {
      // Arrange
      when(mockSessionRepository.create(any)).thenAnswer((
        Invocation invocation,
      ) async {
        final SessionEntity session =
            invocation.positionalArguments[0] as SessionEntity;
        return session;
      });

      // Act
      final SessionEntity result = await useCase.invoke();

      // Assert
      expect(result.title, startsWith('Session '));
      expect(result.title, contains(' '));
    });

    test('doit definir createdAt et updatedAt au meme instant', () async {
      // Arrange
      when(mockSessionRepository.create(any)).thenAnswer((
        Invocation invocation,
      ) async {
        final SessionEntity session =
            invocation.positionalArguments[0] as SessionEntity;
        return session;
      });

      // Act
      final SessionEntity result = await useCase.invoke();

      // Assert
      expect(result.createdAt, equals(result.updatedAt));
    });

    test('doit appeler repository.create avec la session creee', () async {
      // Arrange
      when(mockSessionRepository.create(any)).thenAnswer((
        Invocation invocation,
      ) async {
        final SessionEntity session =
            invocation.positionalArguments[0] as SessionEntity;
        return session;
      });

      // Act
      await useCase.invoke();

      // Assert
      final SessionEntity captured =
          verify(mockSessionRepository.create(captureAny)).captured.single
              as SessionEntity;
      expect(captured.status, equals(SessionStatus.active));
      expect(captured.durationSeconds, isNull);
    });
  });
}
