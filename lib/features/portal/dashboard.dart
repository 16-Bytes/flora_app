import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';
import '../cadastro/cadastro_aluno.dart';
import '../cadastro/cadastro_professor.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = 'Carregando...';
  String userCargo = '...';
  int totalAlunos = 0, processosAtivos = 0, totalEducadores = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    setState(() {
      userName = dados.nome;
      userCargo = dados.cargo;
    });
    if (userCargo.toLowerCase() == 'pedagogia') {
      try {
        final res = await ApiService.get('/api/dashboard');
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['estatisticas'] != null && mounted) {
            setState(() {
              totalAlunos = data['estatisticas']['alunos'] ?? 0;
              totalEducadores = data['estatisticas']['educadores'] ?? 0;
              processosAtivos = data['estatisticas']['processos_ativos'] ?? 0;
            });
          }
        }
      } catch (e) {
        debugPrint('Erro: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: c.headerBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                RepaintBoundary(
                  child: SharedHeader(userName: userName, userCargo: userCargo),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        23,
                        26,
                        23,
                        navH + 16 + bottomInset,
                      ),
                      children: [
                        Text(
                          'Painel de Controle',
                          style: TextStyle(
                            fontSize: 32,
                            height: 38 / 32,
                            fontWeight: FontWeight.w600,
                            color: c.inkDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Aqui está o resumo do seu espaço educativo hoje.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 26 / 16,
                            color: c.subInk,
                          ),
                        ),
                        const SizedBox(height: 18),
                        RepaintBoundary(child: _SearchPill()),
                        const SizedBox(height: 22),
                        if (userCargo.toLowerCase() != 'aluno' &&
                            userCargo.toLowerCase() != 'pais') ...[
                          _StatCard(
                            bg: c.statGreenBg,
                            orbBg: c.statGreenOrb,
                            color: c.statGreenTxt,
                            label: 'Total de alunos',
                            value: totalAlunos.toString(),
                            icon: Icons.groups_rounded,
                          ),
                          const SizedBox(height: 16),
                          _StatCard(
                            bg: c.statYellowBg,
                            orbBg: c.statYellowOrb,
                            color: c.statYellowTxt,
                            label: 'Processos ativos',
                            value: processosAtivos.toString(),
                            icon: Icons.description_rounded,
                          ),
                          const SizedBox(height: 16),
                          _StatCard(
                            bg: c.statPinkBg,
                            orbBg: c.statPinkOrb,
                            color: c.statPinkTxt,
                            label: 'Total de educadores',
                            value: totalEducadores.toString(),
                            icon: Icons.person_add_alt_1_rounded,
                          ),
                          const SizedBox(height: 22),
                          _QuickActionsCard(),
                        ] else
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: c.cardGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Você não tem avaliações ou tarefas pendentes no momento.',
                              style: TextStyle(
                                color: c.ink,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: (size.width - navW) / 2,
              bottom: 8 + bottomInset,
                child: RepaintBoundary(
                  child: SharedBottomNav(currentIndex: 0, userCargo: userCargo, navW: navW),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: c.surfaceCard,
        border: Border.all(color: c.borderLight),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: c.subInkLight),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar alunos, relatórios...',
                hintStyle: TextStyle(color: c.borderLight),
              ),
              style: TextStyle(fontSize: 16, color: c.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.bg,
    required this.orbBg,
    required this.color,
    required this.label,
    required this.value,
    required this.icon,
  });
  final Color bg, orbBg, color;
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.78,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 25,
            width: 48,
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                color: orbBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
          ),
          Positioned(
            left: 96,
            top: 24,
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                height: 20 / 14,
                letterSpacing: 0.28,
              ),
            ),
          ),
          Positioned(
            left: 96,
            top: 44,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                height: 31 / 28,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: c.quickCardBg,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ações Rápidas',
            style: TextStyle(
              fontSize: 15,
              height: 31 / 15,
              fontWeight: FontWeight.w400,
              color: c.quickTxt,
            ),
          ),
          const SizedBox(height: 14),
          _QuickPillButton(
            text: 'Cadastrar Aluno',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CadastroAlunoPage()),
            ),
          ),
          const SizedBox(height: 12),
          _QuickPillButton(
            text: 'Cadastrar Educador',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CadastroProfessorPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickPillButton extends StatelessWidget {
  const _QuickPillButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 47,
      width: double.infinity,
      child: Material(
        color: c.quickBtnBg,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_add_alt_1, size: 18, color: c.quickTxt),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.0,
                    letterSpacing: 0.70,
                    color: c.quickTxt,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
