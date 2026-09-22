import 'package:flutter/material.dart';
import 'lib/screens/login.dart';

void main() {
  runApp(const SolidarityApp());
}

class SolidarityApp extends StatelessWidget {
  const SolidarityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plataforma Solidária',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFAFAFA),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}