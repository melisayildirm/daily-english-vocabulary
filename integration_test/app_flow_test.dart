import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:daily_english_vocabulary/firebase_options.dart';
import 'package:daily_english_vocabulary/screens/level/level_selection_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  Future<void> pumpLevelScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: LevelSelectionScreen(),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('Daily English Vocabulary Integration Testleri', () {
    testWidgets(
      'IT-01 Kullanıcı seviye seçip HomeScreen ekranına geçebilmeli',
      (WidgetTester tester) async {
        await pumpLevelScreen(tester);

        await tester.tap(find.text('A1'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Öğrenmeye Başla'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.text('A1 Seviyesi'), findsOneWidget);
        expect(find.text('Bugün 11 kelime öğren'), findsOneWidget);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );

    testWidgets(
      'IT-02 Kullanıcı B2 seviyesi ile HomeScreen ekranına geçebilmeli',
      (WidgetTester tester) async {
        await pumpLevelScreen(tester);

        await tester.tap(find.text('B2'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Öğrenmeye Başla'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.text('B2 Seviyesi'), findsOneWidget);
        expect(find.text('Bugün 10 kelime öğren'), findsOneWidget);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );

    testWidgets(
      'IT-03 Kullanıcı günlük hedefi azaltıp HomeScreen ekranına geçebilmeli',
      (WidgetTester tester) async {
        await pumpLevelScreen(tester);

        await tester.tap(find.byIcon(Icons.remove));
        await tester.pumpAndSettle();

        expect(find.text('9'), findsOneWidget);

        await tester.tap(find.text('Öğrenmeye Başla'));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.text('B1 Seviyesi'), findsOneWidget);
        expect(find.text('Bugün 9 kelime öğren'), findsOneWidget);

        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
      },
    );
  });
}