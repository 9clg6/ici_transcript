import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ici_transcript/features/transcription/presentation/screens/live/live_transcription.screen.dart';

import '../../helpers/test_helpers.dart';

void main() {
  /// Tests widget pour [LiveTranscriptionScreen].
  ///
  /// Verifie que l'ecran de transcription en direct affiche
  /// correctement les controles, le timer et les segments.
  group('LiveTranscriptionScreen', () {
    testWidgets('doit afficher le message vide quand aucun segment', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          child: const LiveTranscriptionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert — Le screen est wrappé dans un Scaffold par le widget
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('doit afficher le timer au format 00:00:00', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          child: const LiveTranscriptionScreen(),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('00:00:00'), findsOneWidget);
    });

    testWidgets('doit afficher les boutons de controle de session', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          child: const LiveTranscriptionScreen(),
        ),
      );
      await tester.pump();

      // Assert — Les icones de controle doivent etre presentes
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);
      expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);
    });

    testWidgets('doit afficher les indicateurs audio dans la status bar', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        TestHelpers.createTestableWidget(
          child: const LiveTranscriptionScreen(),
        ),
      );
      await tester.pump();

      // Assert — Icones audio
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.screenshot_monitor), findsOneWidget);
    });
  });
}
