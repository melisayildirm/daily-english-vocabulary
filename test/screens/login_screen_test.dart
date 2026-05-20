import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_english_vocabulary/screens/auth/login_screen.dart';

void main() {
  group('Login Screen Widget Testleri', () {

    testWidgets(
      'WT-01 Login ekranı doğru açılmalı',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.text('Giriş Yap'), findsOneWidget);
      },
    );

    testWidgets(
      'WT-02 Email alanına yazı yazılabilmeli',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@test.com',
        );

        expect(find.text('test@test.com'), findsOneWidget);
      },
    );

    testWidgets(
      'WT-03 Şifre alanına yazı yazılabilmeli',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('password_field')),
          '123456',
        );

        expect(find.text('123456'), findsOneWidget);
      },
    );

    testWidgets(
      'WT-04 Login butonu ekranda görünmeli',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        expect(
          find.byKey(const Key('login_button')),
          findsOneWidget,
        );
      },
    );
  });
}