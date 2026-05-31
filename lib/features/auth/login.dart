import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../portal/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final senha = _senhaCtrl.text;
    if (email.isEmpty || senha.isEmpty) {
      setState(() => errorMessage = 'Preencha email e senha.');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() { errorMessage = null; isLoading = true; });
    bool ok = false;
    try {
      final res = await ApiService.post('/api/login', body: {'email': email, 'senha': senha}, withAuth: false);
      if (!mounted) return;
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['sucesso'] == true) {
        ok = true;
        // Salva token no secure storage
        await ApiService.saveToken(data['token']);
        // Dados não-sensíveis no SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuario_nome', data['usuario']['nome']);
        await prefs.setString('usuario_cargo', data['usuario']['cargo']);
        invalidarDadosCache();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardPage(),
          transitionsBuilder: (context, anim, secondaryAnimation, child) => FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut), child: child),
        ));
      } else {
        setState(() => errorMessage = data['erro'] ?? 'Erro ao fazer login.');
      }
    } on TimeoutException {
      if (mounted) setState(() => errorMessage = 'Tempo esgotado. Verifique sua internet.');
    } catch (e) {
      if (mounted) setState(() => errorMessage = 'Erro de conexão com o servidor.');
    } finally {
      if (mounted && !ok) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final side = w <= 360 ? 20.0 : 40.0;

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(child: SizedBox(
            width: double.infinity, height: h.clamp(700.0, 900.0),
            child: Stack(children: [
              Positioned(left: 0, right: 0, top: -25, child: Container(height: 365, decoration: BoxDecoration(color: c.cardCream, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))))),
              Positioned(top: 110, left: (w - 156.48) / 2, child: Image.asset('assets/images/logo.png', width: 156.48, height: 176, fit: BoxFit.contain)),
              Positioned(top: 355, left: (w - 132) / 2, child: SizedBox(width: 132, height: 63, child: Align(alignment: Alignment.center, child: Text('Login', textAlign: TextAlign.center, style: TextStyle(fontSize: 48, height: 58 / 48, fontWeight: FontWeight.w400, color: c.ink))))),
              if (errorMessage != null) Positioned(left: side, right: side, top: 420, child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: c.errorBg, borderRadius: BorderRadius.circular(10)), child: Text(errorMessage!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: c.errorText)))),
              Positioned(left: side, right: side, top: 465, child: _PillField(icon: Icon(Icons.person_outline, size: 18, color: c.ink), hintText: 'Digite seu e-mail', controller: _emailCtrl, keyboardType: TextInputType.emailAddress, obscureText: false)),
              Positioned(left: side, right: side, top: 535, child: _PillField(icon: Icon(Icons.lock_outline, size: 18, color: c.ink), hintText: 'Digite sua senha', controller: _senhaCtrl, keyboardType: TextInputType.visiblePassword, obscureText: true)),
              Positioned(left: side, right: side, top: 620, child: SizedBox(height: 52, child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: c.btnPrimary, foregroundColor: c.scaffoldBg, shape: const StadiumBorder(), elevation: 0, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: isLoading ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: c.scaffoldBg)) : const Text('Entrar', style: TextStyle(fontSize: 14, height: 20 / 14, letterSpacing: 0.28, fontWeight: FontWeight.w400)),
              ))),
              Positioned(bottom: 40, left: (w - 278) / 2, child: SizedBox(width: 278, height: 31, child: Align(alignment: Alignment.center, child: Text('\u201COnde cada mente floresce\u201D', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, height: 30 / 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: c.ink))))),
            ]),
          ));
        }),
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.icon, required this.hintText, required this.controller, required this.keyboardType, required this.obscureText});
  final Widget icon;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 59.59,
      decoration: BoxDecoration(color: c.scaffoldBg, borderRadius: BorderRadius.circular(9999), border: Border.all(color: c.ink, width: 1), boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 2, offset: Offset(0, 1))]),
      child: Row(children: [
        const SizedBox(width: 20),
        SizedBox(width: 20, height: 24, child: Align(alignment: Alignment.centerLeft, child: icon)),
        const SizedBox(width: 12),
        Container(width: 1, height: 24, color: c.ink),
        const SizedBox(width: 12),
        Expanded(child: TextField(controller: controller, keyboardType: keyboardType, obscureText: obscureText, style: TextStyle(fontSize: 16, height: 22 / 16, fontWeight: FontWeight.w400, color: c.ink), decoration: InputDecoration(hintText: hintText, hintStyle: TextStyle(color: c.subInkLight), border: InputBorder.none, isDense: true))),
        const SizedBox(width: 20),
      ]),
    );
  }
}