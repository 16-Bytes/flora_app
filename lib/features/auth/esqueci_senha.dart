import 'package:flutter/material.dart';

/// Placeholder para a futura tela de recuperação de senha.
class EsqueciSenhaPage extends StatelessWidget {
  const EsqueciSenhaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Esqueci minha senha')),
      body: const Center(child: Text('Recuperação de senha em breve.')),
    );
  }
}
