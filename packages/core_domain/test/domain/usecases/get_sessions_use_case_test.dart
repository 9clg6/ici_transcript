import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:core_domain/domain/repositories/session.repository.dart';
import 'package:core_domain/domain/usecases/get_sessions.use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionRepository])
import 'get_sessions_use_case_test.mocks.dart';

void main() {
  /// Tests unitaires pour [GetSessionsUseCase].
  ///
  /// Verifie que le use case retourne correctement la liste
  /// des sessions depuis le repository.
  group('GetSessionsUseCase', () {
    late MockSessionRepository mockSessionRepository;
    late GetSessionsUseCase useCase;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      useCase = GetSessionsUseCase(sessionRepository: mockSessionRepository);
    });

    test('doit retourner la liste des sessions depuis le repository', () async {
      // Arrange
      final List<SessionEntity> expectedSessions = <SessionEntity>[
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

      when(
        mockSessionRepository.getAll(),
      ).thenAnswer((_) async => expectedSessions);

      // Act
      final List<SessionEntity> result = await useCase.invoke();

      // Assert
      expect(result, equals(expectedSessions));
      expect(result.length, equals(2));
      verify(mockSessionRepository.getAll()).called(1);
    });

    test('doit retourner une liste vide si aucune session', () async {
      // Arrange
      when(
        mockSessionRepository.getAll(),
      ).thenAnswer((_) async => <SessionEntity>[]);

      // Act
      final List<SessionEntity> result = await useCase.invoke();

      // Assert
      expect(result, isEmpty);
      verify(mockSessionRepository.getAll()).called(1);
    });

    test('doit propager les exceptions du repository', () async {
      // Arrange
      when(
        mockSessionRepository.getAll(),
      ).thenThrow(Exception('Erreur base de donnees'));

      // Act & Assert
      expect(() => useCase.invoke(), throwsA(isA<Exception>()));
    });
  });
}
