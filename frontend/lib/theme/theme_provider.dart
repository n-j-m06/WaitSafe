import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // DARK THEME
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF05060A),
    primaryColor: const Color(0xFFFF4FA3),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF4FA3),
      secondary: Color(0xFFFF85C8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF05060A),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Color(0xFFFF6FB8),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFDF7FB),
    primaryColor: const Color(0xFFFF4FA3),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFFF4FA3),
      secondary: Color(0xFFFF85C8),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFDF7FB),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Color(0xFFFF4FA3),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
