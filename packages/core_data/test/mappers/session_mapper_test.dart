import 'package:core_data/mappers/session.mapper.dart';
import 'package:core_data/model/local/session.local.model.dart';
import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:test/test.dart';

void main() {
  /// Tests unitaires pour les mappers de session.
  ///
  /// Verifie la conversion bidirectionnelle entre
  /// [SessionLocalModel] et [SessionEntity].
  group('SessionMapper', () {
    group('SessionLocalModelX.toEntity()', () {
      test('doit convertir un model local en entite', () {
        // Arrange
        const SessionLocalModel model = SessionLocalModel(
          id: 'session-1',
          title: 'Reunion equipe',
          createdAt: '2026-03-19T10:00:00.000',
          updatedAt: '2026-03-19T10:30:00.000',
          durationSeconds: 1800,
          status: 'completed',
        );

        // Act
        final SessionEntity entity = model.toEntity();

        // Assert
        expect(entity.id, equals('session-1'));
        expect(entity.title, equals('Reunion equipe'));
        expect(entity.createdAt, equals(DateTime(2026, 3, 19, 10, 0)));
        expect(entity.updatedAt, equals(DateTime(2026, 3, 19, 10, 30)));
        expect(entity.durationSeconds, equals(1800));
        expect(entity.status, equals(SessionStatus.completed));
      });

      test('doit gerer durationSeconds null', () {
        // Arrange
        const SessionLocalModel model = SessionLocalModel(
          id: 'session-2',
          title: 'Session active',
          createdAt: '2026-03-19T14:00:00.000',
          updatedAt: '2026-03-19T14:00:00.000',
          status: 'active',
        );

        // Act
        final SessionEntity entity = model.toEntity();

        // Assert
        expect(entity.durationSeconds, isNull);
        expect(entity.status, equals(SessionStatus.active));
      });

      test('doit mapper le statut error', () {
        // Arrange
        const SessionLocalModel model = SessionLocalModel(
          id: 'session-3',
          title: 'Session erreur',
          createdAt: '2026-03-19T16:00:00.000',
          updatedAt: '2026-03-19T16:05:00.000',
          status: 'error',
        );

        // Act
        final SessionEntity entity = model.toEntity();

        // Assert
        expect(entity.status, equals(SessionStatus.error));
      });
    });

    group('SessionEntityToLocalX.toLocalModel()', () {
      test('doit convertir une entite en model local', () {
        // Arrange
        final SessionEntity entity = SessionEntity(
          id: 'session-1',
          title: 'Reunion equipe',
          createdAt: DateTime(2026, 3, 19, 10, 0),
          updatedAt: DateTime(2026, 3, 19, 10, 30),
          durationSeconds: 1800,
          status: SessionStatus.completed,
        );

        // Act
        final SessionLocalModel model = entity.toLocalModel();

        // Assert
        expect(model.id, equals('session-1'));
        expect(model.title, equals('Reunion equipe'));
        expect(model.createdAt, contains('2026-03-19'));
        expect(model.updatedAt, contains('2026-03-19'));
        expect(model.durationSeconds, equals(1800));
        expect(model.status, equals('completed'));
      });

      test('doit gerer durationSeconds null', () {
        // Arrange
        final SessionEntity entity = SessionEntity(
          id: 'session-2',
          title: 'Session active',
          createdAt: DateTime(2026, 3, 19, 14, 0),
          updatedAt: DateTime(2026, 3, 19, 14, 0),
          status: SessionStatus.active,
        );

        // Act
        final SessionLocalModel model = entity.toLocalModel();

        // Assert
        expect(model.durationSeconds, isNull);
        expect(model.status, equals('active'));
      });
    });

    group('Roundtrip', () {
      test(
        'doit preserver les donnees lors d\'un aller-retour entity->model->entity',
        () {
          // Arrange
          final SessionEntity original = SessionEntity(
            id: 'session-roundtrip',
            title: 'Test roundtrip',
            createdAt: DateTime(2026, 3, 19, 10, 0),
            updatedAt: DateTime(2026, 3, 19, 10, 45),
            durationSeconds: 2700,
            status: SessionStatus.completed,
          );

          // Act
          final SessionLocalModel model = original.toLocalModel();
          final SessionEntity restored = model.toEntity();

          // Assert
          expect(restored.id, equals(original.id));
          expect(restored.title, equals(original.title));
          expect(restored.createdAt, equals(original.createdAt));
          expect(restored.updatedAt, equals(original.updatedAt));
          expect(restored.durationSeconds, equals(original.durationSeconds));
          expect(restored.status, equals(original.status));
        },
      );

      test(
        'doit preserver les donnees lors d\'un aller-retour model->entity->model',
        () {
          // Arrange
          const SessionLocalModel original = SessionLocalModel(
            id: 'session-roundtrip-2',
            title: 'Test roundtrip model',
            createdAt: '2026-03-19T09:00:00.000',
            updatedAt: '2026-03-19T10:00:00.000',
            durationSeconds: 3600,
            status: 'completed',
          );

          // Act
          final SessionEntity entity = original.toEntity();
          final SessionLocalModel restored = entity.toLocalModel();

          // Assert
          expect(restored.id, equals(original.id));
          expect(restored.title, equals(original.title));
          expect(restored.durationSeconds, equals(original.durationSeconds));
          expect(restored.status, equals(original.status));
        },
      );
    });
  });
}
