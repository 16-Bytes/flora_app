import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../features/auth/login.dart';
import '../../main.dart';

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});
  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  String userName = 'Carregando...', userCargo = '...', userEmail = 'carregando...';
  bool notificacoesAtivas = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    _verificarNotificacao();
  }

  Future<void> _carregarDados() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    setState(() {
      userName = dados.nome;
      userCargo = dados.cargo;
      userEmail = '${userName.split(' ').first.toLowerCase()}@flora.com';
    });
  }

  Future<void> _verificarNotificacao() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) setState(() => notificacoesAtivas = prefs.getBool('notificacoes_ativas') ?? false);
  }

  Future<void> _toggleNotificacao() async {
    if (!notificacoesAtivas) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notificacoes_ativas', true);
        if (mounted) setState(() => notificacoesAtivas = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de notificações negada.')),
          );
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificacoes_ativas', false);
      if (mounted) setState(() => notificacoesAtivas = false);
    }
  }

  Future<void> _fazerLogout() async {
    await ApiService.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    invalidarDadosCache();

    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = themeController.isDark;

    return Scaffold(
      backgroundColor: c.headerBg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          // Header simplificado
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            child: Row(children: [
              Container(width: 45, height: 45, decoration: BoxDecoration(color: c.cardCream, borderRadius: BorderRadius.circular(999)), child: Icon(Icons.person, color: c.ink)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(userName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: c.ink)),
                const SizedBox(height: 2),
                Text('Acesso: $userCargo', style: TextStyle(fontSize: 10, color: c.ink)),
              ])),
            ]),
          ),

          // Conteúdo
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: ListView(padding: const EdgeInsets.all(24), children: [
              Text('Configurações', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: c.ink)),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: c.cardGreen, borderRadius: BorderRadius.circular(20)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Voltar
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: c.btnPrimary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.arrow_back, size: 16), label: const Text('Voltar'),
                  ),
                  const SizedBox(height: 20),

                  // ─── Tema toggle ──────────────────────────────────────────
                  Center(child: Text('Tema:', style: TextStyle(color: c.ink, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 8),
                  _ThemeToggle(
                    isDarkActive: isDark,
                    onTap: () => themeController.toggleTheme(),
                  ),
                  const SizedBox(height: 20),

                  // ─── Notificações toggle ──────────────────────────────────
                  Center(child: Text('Notificações:', style: TextStyle(color: c.ink, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 8),
                  _NotifToggle(
                    isEnabled: notificacoesAtivas,
                    onTap: _toggleNotificacao,
                  ),
                  const SizedBox(height: 20),

                  Divider(color: c.ink.withAlpha(60), thickness: 0.5),
                  const SizedBox(height: 10),

                  // Perfil
                  Center(child: Text('Perfil conectado:', style: TextStyle(color: c.ink, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 12),
                  Text('Usuário: $userName', style: TextStyle(color: c.ink, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('Email: $userEmail', style: TextStyle(color: c.ink, fontSize: 13)),
                  const SizedBox(height: 20),

                  Row(children: [
                    Expanded(child: ElevatedButton.icon(
                      onPressed: _fazerLogout,
                      style: ElevatedButton.styleFrom(backgroundColor: c.headerBg, foregroundColor: c.ink, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      icon: const Icon(Icons.logout, size: 16), label: const Text('Sair'),
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edição em breve!'))),
                      style: ElevatedButton.styleFrom(backgroundColor: c.btnSecondary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      icon: const Icon(Icons.edit, size: 16), label: const Text('Editar'),
                    )),
                  ]),
                ]),
              ),
            ]),
          )),
        ]),
      ),
    );
  }
}

/// Toggle de tema com knob que desliza entre ☀️ claro (esquerda) e 🌙 escuro (direita).
/// O knob sempre mostra o ícone do modo ATIVO.
class _ThemeToggle extends StatelessWidget {
  final bool isDarkActive;
  final VoidCallback onTap;
  const _ThemeToggle({required this.isDarkActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Modo claro:', style: TextStyle(fontSize: 10, color: c.ink)),
        Text('Modo escuro:', style: TextStyle(fontSize: 10, color: c.ink)),
      ]),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(color: c.btnPrimary, borderRadius: BorderRadius.circular(999)),
          child: Stack(children: [
            // Ícones estáticos no fundo (mostram o que NÃO está ativo, como dica visual)
            Row(children: [
              Expanded(child: Center(child: AnimatedOpacity(
                opacity: isDarkActive ? 0.3 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 18),
              ))),
              Expanded(child: Padding(padding: const EdgeInsets.only(right: 20), child: Center(child: AnimatedOpacity(
                opacity: isDarkActive ? 0.0 : 0.3,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.nightlight_round, color: Colors.white, size: 18),
              )))),
            ]),
            // Knob animado — mostra ícone do estado ativo
            AnimatedAlign(
              alignment: isDarkActive ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: 37, height: 37,
                  decoration: BoxDecoration(color: c.cardGreen, shape: BoxShape.circle),
                  child: Icon(
                    isDarkActive ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: c.ink, size: 18,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}

/// Toggle de notificações: esquerda = desativado (off), direita = ativado (on).
/// O knob mostra o ícone do estado ATUAL.
class _NotifToggle extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;
  const _NotifToggle({required this.isEnabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Desativada:', style: TextStyle(fontSize: 10, color: c.ink)),
        Text('Ativada:', style: TextStyle(fontSize: 10, color: c.ink)),
      ]),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45,
          decoration: BoxDecoration(color: c.btnPrimary, borderRadius: BorderRadius.circular(999)),
          child: Stack(children: [
            // Ícones de fundo (dica visual do lado oposto)
            // colocar os icon de notificações para o lado direito
            Row(children: [
              Expanded(child: Center(child: AnimatedOpacity(
                opacity: isEnabled ? 0.3 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.notifications_off, color: Colors.white, size: 18),
              ))),
              Expanded(child: Center(child: AnimatedOpacity(
                opacity: isEnabled ? 0.0 : 0.3,
                duration: const Duration(milliseconds: 250),
                child: Icon(Icons.notifications_active, color: Colors.white, size: 18),
              ))),
            ]),
            // Knob — esquerda = off, direita = on
            AnimatedAlign(
              alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: 37, height: 37,
                  decoration: BoxDecoration(color: c.cardGreen, shape: BoxShape.circle),
                  child: Icon(
                    isEnabled ? Icons.notifications_active : Icons.notifications_off,
                    color: c.ink, size: 18,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}
