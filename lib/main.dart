import 'package:flutter/material.dart';
import 'services/auth_storage.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SolidarityApp());
}

class SolidarityApp extends StatelessWidget {
  const SolidarityApp({super.key});

  Future<Widget> _checkInitialRoute() async {
    final token = await AuthStorage.getToken();
    final role = await AuthStorage.getRole();

    if (token != null && role != null) {
      return HomeScreen(userRole: role);
    }
    return const LoginScreen();
  }

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
      home: FutureBuilder<Widget>(
        future: _checkInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.teal)),
            );
          }
          return snapshot.data ?? const LoginScreen();
        },
      ),
    );
  }
}