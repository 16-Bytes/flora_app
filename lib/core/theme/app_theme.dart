import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Gera os ThemeData completos para cada modo de tema.
///
/// As instâncias são cacheadas como `static final` para evitar
/// recriação a cada build(). O Flutter pode fazer `identical()` check
/// e pular rebuilds desnecessários.
abstract final class AppTheme {
  static final _light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.light().surface,
    extensions: [AppColors.light()],
  );

  static final _dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.dark().surface,
    extensions: [AppColors.dark()],
  );

  static final _highContrast = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.highContrast().surface,
    extensions: [AppColors.highContrast()],
  );

  static ThemeData light() => _light;
  static ThemeData dark() => _dark;
  static ThemeData highContrast() => _highContrast;
}
