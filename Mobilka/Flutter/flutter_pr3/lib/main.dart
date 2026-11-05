import 'package:flutter/material.dart';
import 'core/di.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const CatAtlasApp());
}

class CatAtlasApp extends StatelessWidget {
  const CatAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF20251F);
    const green = Color(0xFF536B50);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat Atlas',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F5F0),
        colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F5F0), foregroundColor: ink),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
