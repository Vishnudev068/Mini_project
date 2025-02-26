import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4/splash_screen.dart';
import 'package:flutter_application_4/theme_provider.dart'; // Import the theme provider

const SAVE_KEY = "user logged";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));

  Future.delayed(Duration(seconds: 3), () {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ), // Theme Provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Apply theme dynamically
      theme: lightTheme, // Light Theme
      darkTheme: darkTheme, // Dark Theme
      home: splashscreen(),
    );
  }
}

// ✅ Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color.fromARGB(255, 21, 61, 138),
  scaffoldBackgroundColor: Color.fromARGB(255, 239, 245, 235),
  cardColor: Color.fromARGB(255, 245, 250, 242),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(255, 239, 245, 235),
    foregroundColor: Colors.black,
  ),
  cardTheme: CardTheme(
    // ✅ Light mode container colo
    shadowColor: Colors.grey.withOpacity(0.3), // ✅ Soft shadow in light mode
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 239, 245, 235),
  ),
);

// ✅ Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color.fromARGB(255, 22, 24, 55),
  primaryColor: Color.fromARGB(255, 57, 77, 127),
  cardColor: Color.fromARGB(255, 30, 40, 80),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromARGB(125, 22, 24, 55),
    foregroundColor: Colors.white,
  ),
  cardTheme: CardTheme(
    // color: Color.fromARGB(255, 47, 62, 105),
    shadowColor: Colors.black54,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 22, 24, 55),
  ),
);
