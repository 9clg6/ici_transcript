import 'package:core_domain/domain/entities/session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/session_status.enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ici_transcript/features/history/presentation/screens/detail/session_detail.state.dart';

import '../../helpers/fake_data.dart';

void main() {
  /// Tests widget pour le detail d'une session.
  ///
  /// Verifie que le state et les donnees associees sont corrects.
  group('SessionDetailState', () {
    test('doit creer un etat initial avec une liste de segments vide', () {
      // Act
      final SessionDetailState state = SessionDetailState.initial();

      // Assert
      expect(state.session, isNull);
      expect(state.segments, isEmpty);
      expect(state.isEditing, isFalse);
    });

    test('doit creer un etat avec session et segments', () {
      // Arrange
      final SessionEntity session = FakeData.createSession(
        id: 'session-detail',
        title: 'Session de detail',
        status: SessionStatus.completed,
        durationSeconds: 1800,
      );
      final List<TranscriptSegmentEntity> segments = FakeData.createSegmentList(
        sessionId: 'session-detail',
        count: 3,
      );

      // Act
      final SessionDetailState state = SessionDetailState(
        session: session,
        segments: segments,
      );

      // Assert
      expect(state.session, isNotNull);
      expect(state.session!.id, equals('session-detail'));
      expect(state.segments.length, equals(3));
      expect(state.isEditing, isFalse);
    });

    test('doit supporter copyWith pour le mode edition', () {
      // Arrange
      final SessionDetailState state = SessionDetailState(
        session: FakeData.createSession(),
        segments: FakeData.createSegmentList(count: 1),
      );

      // Act
      final SessionDetailState editingState = state.copyWith(isEditing: true);

      // Assert
      expect(editingState.isEditing, isTrue);
      expect(editingState.session, equals(state.session));
    });
  });
}
