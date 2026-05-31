import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Extension para acessar AppColors de forma simples via context.
///
/// Uso: `final c = context.colors;` → `c.ink`, `c.surface`, etc.
extension ThemeExt on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
