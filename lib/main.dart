import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'dashboard.dart'; 

void main() async {
  // obrigatório sempre que for rodar código assíncrono jurrooo
  // antes do runApp() iniciar o Flutter kct.
  WidgetsFlutterBinding.ensureInitialized();

  // Verifica no cofre do celular se já existe um token de sessão salvo se não vai pra login
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  // Define a tela inicial: se tem token, vai pro Dashboard.
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
