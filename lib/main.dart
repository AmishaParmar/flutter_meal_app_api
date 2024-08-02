import 'package:flutter/material.dart';
import 'package:recipes_dummy_api/screens/login.dart';
import 'package:recipes_dummy_api/screens/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
