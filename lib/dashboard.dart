import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_bottom_nav.dart';
import 'configuracoes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const headerBg = Color(0xFF97C2C1);
  static const surface = Color(0xFFFEF9F2);
  static const ink = Color(0xFF304F55);
  static const inkDark = Color(0xFF233B3E);
  static const subInk = Color(0xFF424849);

  // Variáveis para guardar os dados do usuário
  String userName = 'Carregando...';
  String userCargo = '...';

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario();
  }

  // Função assíncrona para buscar os dados no cofre do celular
  Future<void> _carregarDadosDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('usuario_nome') ?? 'Usuário Desconhecido';

      // Pega o cargo e deixa a primeira em maiúsculo e o resto em minúsculo LEMBRETE DE USAR ISSO EM TODAS AS OUTRAS PAGINAS VIU PQ SE NÃO O SHARED_BOTTON_NAV NAO ACOMPANHA A SEÇÃO
      String cargoCru = prefs.getString('usuario_cargo') ?? 'aluno';
      userCargo = cargoCru.replaceFirst(
        cargoCru[0],
        (cargoCru[0]).toUpperCase(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(320.0, 384.0);
    const navH = 112.0;

    return Scaffold(
      backgroundColor: headerBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // ===== HEADER =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4EA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(Icons.person, color: ink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOME DINÂMICO
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: 0.28,
                                fontWeight: FontWeight.bold,
                                color: ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // CARGO DINÂMICO
                            Text(
                              'Acesso: $userCargo',
                              style: const TextStyle(
                                fontSize: 10,
                                height: 14 / 10,
                                letterSpacing: 0.20,
                                color: ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConfiguracoesPage(),
                              ),
                            );
                            // Futuramente aqui chamemos a tela de configurações / logout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: surface,
                            foregroundColor: ink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          icon: const Icon(Icons.settings, size: 16),
                          label: const Text(
                            'Configurações',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== SURFACE/CONTEÚDO =====
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.only(
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
                        const Text(
                          'Painel de Controle',
                          style: TextStyle(
                            fontSize: 32,
                            height: 38 / 32,
                            fontWeight: FontWeight.w600,
                            color: inkDark,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Aqui está o resumo do seu espaço educativo hoje.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 26 / 16,
                            color: subInk,
                          ),
                        ),
                        const SizedBox(height: 18),

                        const _SearchPill(),

                        const SizedBox(height: 22),

                        // Isso aqui eu fiz no pelo viu <3
                        // ===== LÓGICA DE EXIBIÇÃO POR CARGO =====
                        if (userCargo != 'ALUNO' && userCargo != 'PAIS') ...[
                          // VISÃO DA PEDAGOGIA / PROFESSOR
                          const _StatCard(
                            bg: Color(0xFFDCF3ED),
                            orbBg: Color.fromRGBO(30, 51, 55, 0.08),
                            color: Color(0xFF1E3337),
                            label: 'Total de alunos',
                            value: '0',
                            icon: Icons.groups_rounded,
                          ),
                          const SizedBox(height: 16),
                          const _StatCard(
                            bg: Color(0xFFE8E0B0),
                            orbBg: Color.fromRGBO(76, 82, 61, 0.08),
                            color: Color(0xFF4C523D),
                            label: 'Processos ativos',
                            value: '0',
                            icon: Icons.description_rounded,
                          ),
                          const SizedBox(height: 16),
                          const _StatCard(
                            bg: Color(0xFFEFCECB),
                            orbBg: Color.fromRGBO(80, 47, 48, 0.08),
                            color: Color(0xFF502F30),
                            label: 'Total de educadores',
                            value: '0',
                            icon: Icons.person_add_alt_1_rounded,
                          ),
                          const SizedBox(height: 22),
                          const _QuickActionsCard(),
                        ] else ...[
                          // VISÃO DO ALUNO / PAIS
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7E3DF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Você não tem avaliações ou tarefas pendentes no momento.',
                              style: TextStyle(
                                color: ink,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // BOTTOM NAV
            Positioned(
              left: (size.width - navW) / 2,
              bottom: 8 + bottomInset,
              child: SharedBottomNav(
                currentIndex: 0,
                userCargo: userCargo, // Passamos a variável dinâmica pra Ká!
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ COMPONENTES DA TELA =================

class _SearchPill extends StatelessWidget {
  const _SearchPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9F2),
        border: Border.all(color: const Color(0xFFDED1BC)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.search, size: 18, color: Color(0xFF727879)),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar alunos, relatórios...',
                hintStyle: TextStyle(color: Color(0xFFDED1BC)),
              ),
              style: TextStyle(fontSize: 16, color: Color(0xFF304F55)),
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

  final Color bg;
  final Color orbBg;
  final Color color;
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.78,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(58, 82, 85, 0.05),
            blurRadius: 20,
            spreadRadius: -10,
            offset: Offset(0, 4),
          ),
        ],
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
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFCD4A4),
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ações Rápidas',
            style: TextStyle(
              fontSize: 15,
              height: 31 / 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6D4A1B),
            ),
          ),
          const SizedBox(height: 14),

          _QuickPillButton(text: 'Cadastrar Aluno', onTap: () {}),
          const SizedBox(height: 12),
          _QuickPillButton(text: 'Cadastrar Educador', onTap: () {}),
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
    return SizedBox(
      height: 47,
      width: double.infinity,
      child: Material(
        color: const Color(0xFFFFBC69),
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.person_add_alt_1,
                  size: 18,
                  color: Color(0xFF6D4A1B),
                ),
                SizedBox(width: 12),
                _QuickLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLabel extends StatelessWidget {
  const _QuickLabel();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<_QuickPillButton>();
    return Text(
      parent?.text ?? '',
      style: const TextStyle(
        fontSize: 13,
        height: 1.0,
        letterSpacing: 0.70,
        color: Color(0xFF6D4A1B),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
