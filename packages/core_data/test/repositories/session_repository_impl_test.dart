import 'package:core_data/datasources/local/session.local.data_source.dart';
import 'package:core_data/model/local/session.local.model.dart';
import 'package:core_data/repositories/session.repository.impl.dart';
import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(<Type>[SessionLocalDataSource])
import 'session_repository_impl_test.mocks.dart';

void main() {
  /// Tests unitaires pour [SessionRepositoryImpl].
  ///
  /// Verifie que le repository mappe correctement les modeles locaux
  /// vers les entites domain et delegue aux datasources.
  group('SessionRepositoryImpl', () {
    late MockSessionLocalDataSource mockDataSource;
    late SessionRepositoryImpl repository;

    setUp(() {
      mockDataSource = MockSessionLocalDataSource();
      repository = SessionRepositoryImpl(
        sessionLocalDataSource: mockDataSource,
      );
    });

    group('getAll', () {
      test('doit retourner les sessions mappees en entites', () async {
        // Arrange
        final List<SessionLocalModel> localModels = <SessionLocalModel>[
          const SessionLocalModel(
            id: 'session-1',
            title: 'Reunion equipe',
            createdAt: '2026-03-19T10:00:00.000',
            updatedAt: '2026-03-19T10:30:00.000',
            durationSeconds: 1800,
            status: 'completed',
          ),
          const SessionLocalModel(
            id: 'session-2',
            title: 'Call client',
            createdAt: '2026-03-19T14:00:00.000',
            updatedAt: '2026-03-19T14:45:00.000',
            durationSeconds: 2700,
            status: 'completed',
          ),
        ];

        when(mockDataSource.getAll()).thenAnswer((_) async => localModels);

        // Act
        final List<SessionEntity> result = await repository.getAll();

        // Assert
        expect(result.length, equals(2));
        expect(result[0].id, equals('session-1'));
        expect(result[0].title, equals('Reunion equipe'));
        expect(result[0].status, equals(SessionStatus.completed));
        expect(result[1].id, equals('session-2'));
        verify(mockDataSource.getAll()).called(1);
      });

      test('doit retourner une liste vide si aucun model', () async {
        // Arrange
        when(
          mockDataSource.getAll(),
        ).thenAnswer((_) async => <SessionLocalModel>[]);

        // Act
        final List<SessionEntity> result = await repository.getAll();

        // Assert
        expect(result, isEmpty);
      });
    });

    group('getById', () {
      test('doit retourner l\'entite mappee si le model existe', () async {
        // Arrange
        const SessionLocalModel localModel = SessionLocalModel(
          id: 'session-1',
          title: 'Reunion',
          createdAt: '2026-03-19T10:00:00.000',
          updatedAt: '2026-03-19T10:30:00.000',
          status: 'active',
        );

        when(
          mockDataSource.getById('session-1'),
        ).thenAnswer((_) async => localModel);

        // Act
        final SessionEntity? result = await repository.getById('session-1');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('session-1'));
        expect(result.status, equals(SessionStatus.active));
      });

      test('doit retourner null si le model n\'existe pas', () async {
        // Arrange
        when(
          mockDataSource.getById('session-inexistant'),
        ).thenAnswer((_) async => null);

        // Act
        final SessionEntity? result = await repository.getById(
          'session-inexistant',
        );

        // Assert
        expect(result, isNull);
      });
    });

    group('create', () {
      test('doit inserer le model local et retourner l\'entite', () async {
        // Arrange
        final SessionEntity session = SessionEntity(
          id: 'session-new',
          title: 'Nouvelle session',
          createdAt: DateTime(2026, 3, 19, 15, 0),
          updatedAt: DateTime(2026, 3, 19, 15, 0),
          status: SessionStatus.active,
        );

        when(mockDataSource.insert(any)).thenAnswer((_) async {});

        // Act
        final SessionEntity result = await repository.create(session);

        // Assert
        expect(result.id, equals('session-new'));
        verify(mockDataSource.insert(any)).called(1);
      });
    });

    group('update', () {
      test(
        'doit mettre a jour le model local et retourner l\'entite',
        () async {
          // Arrange
          final SessionEntity session = SessionEntity(
            id: 'session-1',
            title: 'Titre mis a jour',
            createdAt: DateTime(2026, 3, 19, 10, 0),
            updatedAt: DateTime(2026, 3, 19, 10, 45),
            durationSeconds: 2700,
            status: SessionStatus.completed,
          );

          when(mockDataSource.update(any)).thenAnswer((_) async {});

          // Act
          final SessionEntity result = await repository.update(session);

          // Assert
          expect(result.title, equals('Titre mis a jour'));
          verify(mockDataSource.update(any)).called(1);
        },
      );
    });

    group('delete', () {
      test('doit appeler delete sur le datasource', () async {
        // Arrange
        when(mockDataSource.delete('session-1')).thenAnswer((_) async {});

        // Act
        await repository.delete('session-1');

        // Assert
        verify(mockDataSource.delete('session-1')).called(1);
      });
    });

    group('watchAll', () {
      test('doit retourner un stream d\'entites mappees', () async {
        // Arrange
        final List<SessionLocalModel> localModels = <SessionLocalModel>[
          const SessionLocalModel(
            id: 'session-1',
            title: 'Reunion',
            createdAt: '2026-03-19T10:00:00.000',
            updatedAt: '2026-03-19T10:30:00.000',
            status: 'completed',
          ),
        ];

        when(
          mockDataSource.watchAll(),
        ).thenAnswer((_) => Stream<List<SessionLocalModel>>.value(localModels));

        // Act
        final List<SessionEntity> result = await repository.watchAll().first;

        // Assert
        expect(result.length, equals(1));
        expect(result[0].id, equals('session-1'));
      });
    });
  });
}
