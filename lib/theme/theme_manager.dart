import 'package:countdown_mobile/theme/dark_theme.dart';
import 'package:countdown_mobile/theme/light_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => lightTheme;
  static ThemeData get dark => darkTheme;

  static ThemeMode get themeMode => ThemeMode.system; // Automatically switch based on system settings
}