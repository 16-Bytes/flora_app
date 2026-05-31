import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla o tema ativo do app e persiste a escolha no armazenamento local.
///
/// Valores possíveis salvos em SharedPreferences:
/// - 'light' (padrão)
/// - 'dark'
/// - 'highContrast'
class ThemeController extends ChangeNotifier {
  static const _key = 'flora_theme_mode';

  String _mode = 'light';
  String get mode => _mode;

  bool get isLight => _mode == 'light';
  bool get isDark => _mode == 'dark';
  bool get isHighContrast => _mode == 'highContrast';

  /// Inicializa o controller lendo a preferência salva.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _mode = prefs.getString(_key) ?? 'light';
    notifyListeners();
  }

  /// Define o tema e persiste.
  Future<void> setTheme(String newMode) async {
    if (_mode == newMode) return;
    _mode = newMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newMode);
  }

  /// Alterna entre claro e escuro.
  Future<void> toggleTheme() async {
    await setTheme(isDark ? 'light' : 'dark');
  }
}
