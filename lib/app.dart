import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

class DailyEnglishApp extends StatelessWidget {
  const DailyEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily English Vocabulary',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}