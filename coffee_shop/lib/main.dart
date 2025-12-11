import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Pro',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFFF9FAFB),

        // Colores
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF1E293B),
          primary: Color(0xFF1E293B),
          secondary: Color(0xFFF97316),
          surface: Colors.white,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF9FAFB),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1E293B)),
        ),

        // Inputs
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF1E293B), width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
