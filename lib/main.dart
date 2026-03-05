import 'package:flutter/material.dart';

import 'screens/plan_ride_screen.dart';

void main() {
  runApp(const CyclingApp());
}

class CyclingApp extends StatelessWidget {
  const CyclingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cycling Agent',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE9E9E9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5A1F),
          primary: const Color(0xFFFF5A1F),
          secondary: const Color(0xFF2F80C8),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF5A1F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: const PlanRideScreen(),
    );
  }
}
