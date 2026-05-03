import 'package:flutter/material.dart';
import 'package:flora/dashboard.dart';
import 'package:flora/alunos.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;
  final String userCargo;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
    required this.userCargo,
  });

  // ====== FUNÇÃO DE NAVEGAÇÃO COM TRANSIÇÃO (FADE) ======
  void _navigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Decide qual menu desenhar baseado no cargo
    if (userCargo == 'PEDAGOGIA') {
      return _buildPedagogiaNav(context);
    } else {
      return _buildStandardNav(context);
    }
  }

  // ===========================================================================
  // MENU 1: PEDAGOGIA (Com notch, botão central e espaçamentos originais)
  // ===========================================================================
  Widget _buildPedagogiaNav(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final navW = (size.width - 24).clamp(320.0, 384.0);

    const navH = 112.0;
    const railH = 84.0;
    const railTop = 28.0;
    const fabSize = 60.0;
    const fabTop = -8.0;
    const notchCenterY = -6.0;

    return SizedBox(
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
                      // --- ABA 0: PAINEL ---
                      _NavTab(
                        active: currentIndex == 0,
                        icon: Icons.grid_view_rounded,
                        label: 'Painel',
                        onTap: () {
                          if (currentIndex != 0)
                            _navigate(context, const DashboardPage());
                        },
                      ),
                      const SizedBox(width: 2),

                      // --- ABA 1: ALUNOS ---
                      _NavTab(
                        active: currentIndex == 1,
                        icon: Icons.groups_2_rounded,
                        label: 'Alunos',
                        onTap: () {
                          if (currentIndex != 1)
                            _navigate(context, const AlunosPage());
                        },
                      ),

                      // O SEGREDO DO SEU CÓDIGO ORIGINAL QUE MANTÉM O BURACO DO BOTÃO
                      const Spacer(),

                      // --- ABA 2: PROFESSOR ---
                      _NavTab(
                        active: currentIndex == 2,
                        icon: Icons.school_rounded,
                        label: 'Professor',
                        onTap: () {},
                      ),
                      const SizedBox(width: 2),

                      // --- ABA 3: DADOS ---
                      _NavTab(
                        active: currentIndex == 3,
                        icon: Icons.storage_rounded,
                        label: 'Dados',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Botão central
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
                  color: Color(0xFF304F55),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MENU 2: PROFESSORES, ALUNOS E PAIS (Pílula lisa com FittedBox anti-quebra)
  // ===========================================================================
  Widget _buildStandardNav(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final navW = (size.width - 24).clamp(320.0, 384.0);

    const navH = 112.0; // Mantém a altura total para a tela não dar "pulo"
    const railH = 84.0;
    const railTop = 28.0;

    return SizedBox(
      width: navW,
      height: navH,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: railTop,
            width: navW,
            height: railH,
            child: Container(
              // Sem ClipPath aqui, apenas a pílula arredondada
              decoration: BoxDecoration(
                color: const Color(0xFFBFDDDC),
                border: Border.all(color: const Color(0xFF9CBBBA)),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  // MÁGICA: Escala o menu se a tela for muito pequena!
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _NavTab(
                        active: currentIndex == 0,
                        icon: Icons.grid_view_rounded,
                        label: 'Painel',
                        onTap: () {
                          if (currentIndex != 0)
                            _navigate(context, const DashboardPage());
                        },
                      ),
                      const SizedBox(width: 4),
                      _NavTab(
                        active: currentIndex == 1,
                        icon: Icons.assignment_rounded,
                        label: 'Formulários',
                        onTap: () {},
                      ),
                      const SizedBox(width: 4),
                      _NavTab(
                        active: currentIndex == 2,
                        icon: Icons.menu_book_rounded,
                        label: 'Materiais',
                        onTap: () {},
                      ),
                      const SizedBox(width: 4),
                      _NavTab(
                        active: currentIndex == 3,
                        icon: Icons.info_outline_rounded,
                        label: 'Informativa',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// O SEU CLIPPER ORIGINAL INTOCADO
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

// A SUA ABA ORIGINAL INTOCADA (Garante que a forma não quebre)
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
            mainAxisSize:
                MainAxisSize.min, // Garante que a caixa "abrace" o texto
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
