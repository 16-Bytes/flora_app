import 'package:flutter/material.dart';

import '../../core/theme/theme_ext.dart';
import '../../features/portal/dashboard.dart';
import '../../features/portal/alunos.dart';
import '../../features/formularios/formulario.dart';
import '../../features/portal/informativa.dart';
import '../../features/portal/materiais.dart';
import '../../features/portal/professor.dart';
import '../../features/portal/dados.dart';
import '../../features/cadastro/escolha_cadastro.dart';

class SharedBottomNav extends StatelessWidget {
  final int currentIndex;
  final String userCargo;
  final double navW;

  const SharedBottomNav({
    super.key,
    required this.currentIndex,
    required this.userCargo,
    required this.navW,
  });

  void _navigate(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: CurveTween(curve: Curves.easeInOut).animate(animation), child: child);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cargoLower = userCargo.toLowerCase();
    if (cargoLower == 'pedagogia' || cargoLower == 'administrativo') {
      return _buildPedagogiaNav(context);
    } else {
      return _buildStandardNav(context);
    }
  }

  Widget _buildPedagogiaNav(BuildContext context) {
    final c = context.colors;
    const navH = 112.0, railH = 84.0, railTop = 28.0;
    const fabSize = 60.0, fabTop = -8.0, notchCenterY = -6.0;

    return SizedBox(width: navW, height: navH, child: Stack(clipBehavior: Clip.none, children: [
      Positioned(left: 0, top: railTop, width: navW, height: railH, child: ClipPath(
        clipper: _NotchedRailClipper(notchRadius: 32, notchCenterX: navW / 2, notchCenterY: notchCenterY),
        child: Container(
          decoration: BoxDecoration(color: c.navBg, border: Border.all(color: c.navBorder), borderRadius: BorderRadius.circular(50)),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Row(children: [
            _NavTab(active: currentIndex == 0, icon: Icons.grid_view_rounded, label: 'Painel', c: c, onTap: () { if (currentIndex != 0) _navigate(context, const DashboardPage()); }),
            const SizedBox(width: 2),
            _NavTab(active: currentIndex == 1, icon: Icons.groups_2_rounded, label: 'Alunos', c: c, onTap: () { if (currentIndex != 1) _navigate(context, const AlunosPage()); }),
            const Spacer(),
            _NavTab(active: currentIndex == 2, icon: Icons.school_rounded, label: 'Professor', c: c, onTap: () { if (currentIndex != 2) _navigate(context, const ProfessorPage()); }),
            const SizedBox(width: 2),
            _NavTab(active: currentIndex == 3, icon: Icons.storage_rounded, label: 'Dados', c: c, onTap: () { if (currentIndex != 3) _navigate(context, const DadosPage()); }),
          ])),
        ),
      )),
      // FAB central → Escolha Cadastro
      Positioned(left: (navW - fabSize) / 2, top: fabTop, width: fabSize, height: fabSize, child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EscolhaCadastroPage())),
        child: Container(
          decoration: BoxDecoration(color: c.navFabBg, border: Border.all(color: c.navBorder), borderRadius: BorderRadius.circular(999),
            boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.18), blurRadius: 10, offset: Offset(0, 6))]),
          child: Icon(Icons.person_add_alt_1, color: c.ink, size: 28),
        ),
      )),
    ]));
  }

  Widget _buildStandardNav(BuildContext context) {
    final c = context.colors;
    const navH = 112.0, railH = 84.0, railTop = 28.0;

    return SizedBox(width: navW, height: navH, child: Stack(children: [
      Positioned(left: 0, top: railTop, width: navW, height: railH, child: Container(
        decoration: BoxDecoration(color: c.navBg, border: Border.all(color: c.navBorder), borderRadius: BorderRadius.circular(50)),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: FittedBox(fit: BoxFit.scaleDown, child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: [
            _NavTab(active: currentIndex == 0, icon: Icons.grid_view_rounded, label: 'Painel', c: c, onTap: () { if (currentIndex != 0) _navigate(context, const DashboardPage()); }),
            const SizedBox(width: 4),
            _NavTab(active: currentIndex == 1, icon: Icons.assignment_rounded, label: 'Formulários', c: c, onTap: () { if (currentIndex != 1) _navigate(context, const FormularioPage()); }),
            const SizedBox(width: 4),
            _NavTab(active: currentIndex == 2, icon: Icons.menu_book_rounded, label: 'Materiais', c: c, onTap: () { if (currentIndex != 2) _navigate(context, const MateriaisPage()); }),
            const SizedBox(width: 4),
            _NavTab(active: currentIndex == 3, icon: Icons.info_outline_rounded, label: 'Informativa', c: c, onTap: () { if (currentIndex != 3) _navigate(context, const InformativaPage()); }),
          ],
        ))),
      )),
    ]));
  }
}

class _NotchedRailClipper extends CustomClipper<Path> {
  _NotchedRailClipper({required this.notchRadius, required this.notchCenterX, required this.notchCenterY});
  final double notchRadius, notchCenterX, notchCenterY;

  @override
  Path getClip(Size size) {
    final rect = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(50)));
    final hole = Path()..addOval(Rect.fromCircle(center: Offset(notchCenterX, notchCenterY), radius: notchRadius));
    return Path.combine(PathOperation.difference, rect, hole);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _NavTab extends StatelessWidget {
  const _NavTab({required this.active, required this.icon, required this.label, required this.c, required this.onTap});
  final bool active;
  final IconData icon;
  final String label;
  final dynamic c;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? c.navActive : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(borderRadius: BorderRadius.circular(999), onTap: onTap,
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: c.ink),
            const SizedBox(width: 6),
            Text(label, maxLines: 1, overflow: TextOverflow.clip, softWrap: false, style: TextStyle(fontSize: 11.5, height: 1.0, letterSpacing: 0.35, color: c.ink)),
          ]))),
    );
  }
}
