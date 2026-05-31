import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/login.dart';
import 'features/portal/dashboard.dart';

/// Instância global do controlador de tema.
/// Acessível em qualquer lugar para mudar o tema.
final themeController = ThemeController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await themeController.init();

  // Verifica se o token salvo ainda é válido
  final tokenValido = await ApiService.isTokenValid();

  runApp(FloraApp(tokenValido: tokenValido));
}

class FloraApp extends StatelessWidget {
  final bool tokenValido;
  const FloraApp({super.key, required this.tokenValido});

  ThemeData _getTheme(String mode) {
    switch (mode) {
      case 'dark':
        return AppTheme.dark();
      case 'highContrast':
        return AppTheme.highContrast();
      default:
        return AppTheme.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder isola o rebuild: quando o tema muda,
    // apenas o MaterialApp é reconstruído — não o FloraApp inteiro.
    // Widgets const filhos (DashboardPage, LoginPage) são preservados.
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Flora',
          debugShowCheckedModeBanner: false,
          theme: _getTheme(themeController.mode),
          themeAnimationDuration: const Duration(milliseconds: 400),
          themeAnimationCurve: Curves.easeInOut,
          home: tokenValido ? const DashboardPage() : const LoginPage(),
        );
      },
    );
  }
}
