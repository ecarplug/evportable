import 'package:flutter/material.dart';

class ThemeStyle {
  static final lightTheme = ThemeData.light().copyWith(
    tabBarTheme: TabBarTheme(labelColor: const Color(0xFF000000)),
    backgroundColor: Colors.blue[800],
    cardColor: const Color(0xFFFFFFFF),
    bottomAppBarColor: Colors.blue[800],
    primaryColorLight: const Color(0xFFF5F5F5),
    primaryColorDark: const Color(0xFFEEEEEE),
  );
  static final darkTheme = ThemeData.dark().copyWith(
    tabBarTheme: TabBarTheme(labelColor: const Color(0xFFFFFFFF)),
    backgroundColor: Colors.blue[800],
    bottomAppBarColor: Colors.blue[800],
    cardColor: Colors.blue[800],
    primaryColorLight: Colors.blue[800],
    primaryColorDark: Colors.blue[800],
  );
  static MediaQueryData _mediaQuery;
  static ThemeData theme;
  static ThemeData getTheme(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    theme = _mediaQuery.platformBrightness == Brightness.light
        ? lightTheme
        : darkTheme;
    return theme;
  }
}
