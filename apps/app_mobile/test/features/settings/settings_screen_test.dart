import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_data.dart';
import '../../helpers/test_helpers.dart';

void main() {
  /// Tests pour l'ecran de preferences.
  ///
  /// L'ecran de preferences n'est pas encore implemente.
  /// Ces tests verifient les donnees de test et la structure
  /// en attendant l'implementation de la fonctionnalite FR-006.4.
  group('SettingsScreen (placeholder)', () {
    test('doit creer des peripheriques audio de test', () {
      // Act
      final List<dynamic> devices = FakeData.createAudioDeviceList();

      // Assert
      expect(devices.length, equals(3));
      expect(devices[0].name, equals('MacBook Pro Microphone'));
      expect(devices[0].isInput, isTrue);
      expect(devices[2].name, equals('ScreenCaptureKit'));
      expect(devices[2].isInput, isFalse);
    });

    test('doit creer un peripherique audio input par defaut', () {
      // Act
      final dynamic device = FakeData.createAudioDevice();

      // Assert
      expect(device.id, equals('device-1'));
      expect(device.name, equals('MacBook Pro Microphone'));
      expect(device.isInput, isTrue);
    });

    test('doit creer un peripherique audio output', () {
      // Act
      final dynamic device = FakeData.createAudioDevice(
        id: 'output-1',
        name: 'ScreenCaptureKit',
        isInput: false,
      );

      // Assert
      expect(device.id, equals('output-1'));
      expect(device.name, equals('ScreenCaptureKit'));
      expect(device.isInput, isFalse);
    });

    testWidgets('doit rendre un placeholder settings dans un Scaffold', (
      WidgetTester tester,
    ) async {
      // Arrange : un placeholder simple pour les futurs settings
      await tester.pumpWidget(
        TestHelpers.createTestableWidgetWithScaffold(
          child: const Column(
            children: <Widget>[Icon(Icons.settings), Text('Preferences')],
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
    });
  });
}
