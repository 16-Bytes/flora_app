import 'package:flutter/material.dart';

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

  int active = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    final navW = (size.width - 24).clamp(320.0, 384.0);

    final navH = 112.0;
    final railH = 84.0;
    final railTop = 28.0;

    final fabSize = 60.0;

    // Ajuste principal: subir o botão central para não cortar “Professor/Alunos”.
    // Era top: 10
    final fabTop = -8.0;

    // Notch também um pouco mais “alto” para acompanhar o botão.
    final notchCenterY = -6.0;

    return Scaffold(
      backgroundColor: headerBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Henrique Oliveira',
                              style: TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: 0.28,
                                color: ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Acesso administrativo',
                              style: TextStyle(
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
                          onPressed: () {},
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
                        _SearchPill(),
                        const SizedBox(height: 22),
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
                        _QuickActionsCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Bottom nav overlay
            Positioned(
              left: (size.width - navW) / 2,
              bottom: 8 + bottomInset,
              width: navW,
              height: navH,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    top: railTop,
                    width: navW,
                    height: railH,
                    child: ClipPath(
                      clipper: _NotchedRailClipper(
                        notchRadius: 32,
                        notchCenterX: navW / 2,
                        notchCenterY: notchCenterY,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFBFDDDC),
                          border: Border.all(color: const Color(0xFF9CBBBA)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              _NavTab(
                                active: active == 0,
                                icon: Icons.grid_view_rounded,
                                label: 'Painel',
                                onTap: () => setState(() => active = 0),
                              ),
                              const SizedBox(width: 2),
                              _NavTab(
                                active: active == 1,
                                icon: Icons.groups_2_rounded,
                                label: 'Alunos',
                                onTap: () => setState(() => active = 1),
                              ),
                              const Spacer(),
                              _NavTab(
                                active: active == 2,
                                icon: Icons.school_rounded,
                                label: 'Professor',
                                onTap: () => setState(() => active = 2),
                              ),
                              const SizedBox(width: 2),
                              _NavTab(
                                active: active == 3,
                                icon: Icons.storage_rounded,
                                label: 'Dados',
                                onTap: () => setState(() => active = 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Botão central (subido)
                  Positioned(
                    left: (navW - fabSize) / 2,
                    top: fabTop,
                    width: fabSize,
                    height: fabSize,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Adicionar (em breve)')),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB4D4D3),
                          border: Border.all(color: const Color(0xFF9CBBBA)),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.18),
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1,
                          color: ink,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
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

          // Botões manuais (alinhamento perfeito)
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
            // Centraliza o conjunto ícone+texto no “meio real” do botão
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

// Separado só para garantir altura e baseline consistentes.
class _QuickLabel extends StatelessWidget {
  const _QuickLabel();

  @override
  Widget build(BuildContext context) {
    // O texto do botão no HTML tem um “line-height” alto (30px),
    // mas visualmente fica bem centralizado. Aqui deixamos compacto e central.
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

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.active,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? const Color(0xFFFEF9F2) : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: const Color(0xFF304F55)),
              const SizedBox(width: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.0,
                  letterSpacing: 0.35,
                  color: Color(0xFF304F55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotchedRailClipper extends CustomClipper<Path> {
  _NotchedRailClipper({
    required this.notchRadius,
    required this.notchCenterX,
    required this.notchCenterY,
  });

  final double notchRadius;
  final double notchCenterX;
  final double notchCenterY;

  @override
  Path getClip(Size size) {
    final rect = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(50)),
      );

    final hole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(notchCenterX, notchCenterY),
          radius: notchRadius,
        ),
      );

    return Path.combine(PathOperation.difference, rect, hole);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
