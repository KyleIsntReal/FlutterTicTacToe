import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
  
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  bool getIsDarkMode() {
    return _isDarkMode; // Public getter method
  }

  void toggleTheme(bool isOn) {
    setState(() {
      _isDarkMode = isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StarWars TicTacToe',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SplashScreen(),
    );
  }
}
