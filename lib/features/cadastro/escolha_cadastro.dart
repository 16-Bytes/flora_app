import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';
import 'cadastro_aluno.dart';
import 'cadastro_professor.dart';

class EscolhaCadastroPage extends StatefulWidget {
  const EscolhaCadastroPage({super.key});
  @override
  State<EscolhaCadastroPage> createState() => _EscolhaCadastroPageState();
}

class _EscolhaCadastroPageState extends State<EscolhaCadastroPage> {
  String userName = 'Carregando...', userCargo = '...';

  @override
  void initState() { super.initState(); _carregar(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (mounted) setState(() { userName = dados.nome; userCargo = dados.cargo; });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(backgroundColor: c.headerBg, body: SafeArea(bottom: false, child: Stack(children: [
      Column(children: [
        RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset), children: [
            Text('Escolha o Cadastro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
            const SizedBox(height: 40),

            // Card Alunos
            _CadastroCard(
              label: 'Alunos',
              icon: Icons.menu_book_rounded,
              bgColor: c.cadastroAlunoBg,
              iconColor: c.cadastroAlunoBorder,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroAlunoPage())),
            ),
            const SizedBox(height: 24),

            // Card Professor
            _CadastroCard(
              label: 'Professor',
              icon: Icons.badge_rounded,
              bgColor: c.cadastroProfBg,
              iconColor: c.cadastroProfBorder,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroProfessorPage())),
            ),
          ]),
        )),
      ]),
      Positioned(left: (size.width - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: -1, userCargo: userCargo, navW: navW))),
    ])));
  }
}

class _CadastroCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor, iconColor;
  final VoidCallback onTap;
  const _CadastroCard({required this.label, required this.icon, required this.bgColor, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(onTap: onTap, child: Container(
      height: 140, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(32), boxShadow: const [AppColors.cardShadow]),
      child: Stack(children: [
        Positioned(right: -10, bottom: -20, child: Icon(icon, size: 140, color: iconColor.withAlpha(40))),
        Align(alignment: Alignment.centerLeft, child: Text(label, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: c.inkDark))),
      ]),
    ));
  }
}
