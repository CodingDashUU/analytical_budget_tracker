import 'package:flutter/material.dart';
import 'services/router.dart';

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MainRouter,
      title: 'Budget Tracker',
      theme: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    ),

      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
