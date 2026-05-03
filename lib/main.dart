import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'dashboard.dart'; // Lembre-se de importar o dashboard aqui!

void main() async {
  // Isso é obrigatório sempre que formos rodar código assíncrono (await)
  // antes do runApp() iniciar o Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica no cofre do celular se já existe um token de sessão salvo
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  // Define a tela inicial: se tem token, vai pro Dashboard. Se não tem, vai pro Login.
  Widget telaInicial = const LoginPage();

  if (token != null && token.isNotEmpty) {
    telaInicial = const DashboardPage();
  }

  runApp(MyApp(telaInicial: telaInicial));
}

class MyApp extends StatelessWidget {
  final Widget telaInicial;

  const MyApp({super.key, required this.telaInicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: telaInicial);
  }
}
