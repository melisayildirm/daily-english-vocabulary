import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_english_vocabulary/screens/level/level_selection_screen.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpLevelScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: LevelSelectionScreen(),
      ),
    );
  }

  group('Level Selection Screen Widget Testleri', () {
    testWidgets('WT-01 Seviye seçim ekranı doğru açılmalı',
        (WidgetTester tester) async {
      await pumpLevelScreen(tester);

      expect(find.text('Seviye ve Hedef'), findsOneWidget);
      expect(find.text('Bugünkü öğrenme planını belirle'), findsOneWidget);
      expect(find.text('Öğrenmeye Başla'), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('WT-02 Tüm seviye seçenekleri ekranda görünmeli',
        (WidgetTester tester) async {
      await pumpLevelScreen(tester);

      expect(find.text('A1'), findsOneWidget);
      expect(find.text('A2'), findsOneWidget);
      expect(find.text('B1'), findsOneWidget);
      expect(find.text('B2'), findsOneWidget);
      expect(find.text('C1'), findsOneWidget);
      expect(find.text('C2'), findsOneWidget);

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('WT-03 Günlük kelime hedefi başlangıçta 10 olmalı',
        (WidgetTester tester) async {
      await pumpLevelScreen(tester);

      expect(find.text('10'), findsOneWidget);
      expect(
        find.text('Bugün 10 kelime öğrenmeyi hedefliyorsun.'),
        findsOneWidget,
      );

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('WT-04 Artırma butonuna basılınca kelime hedefi 11 olmalı',
        (WidgetTester tester) async {
      await pumpLevelScreen(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('11'), findsOneWidget);
      expect(
        find.text('Bugün 11 kelime öğrenmeyi hedefliyorsun.'),
        findsOneWidget,
      );

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}