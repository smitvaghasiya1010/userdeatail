import 'package:flutter/material.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Root widget of the User Directory application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Curated primary seed color for a modern, sleek appearance
    const seedColor = Color(0xFF1E6091);

    return MaterialApp(
      title: 'Users',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      // Light Theme configuration
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
        ),
      ),
      // Dark Theme configuration
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
        ),
      ),
      home: const UserListScreen(),
    );
  }
}
