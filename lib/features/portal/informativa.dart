import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class NeuroInfo {
  final String titulo, imagemAsset, subtitulo, textoLongo;
  final IconData iconeFallback;
  final Color corFundo;
  NeuroInfo({required this.titulo, required this.imagemAsset, required this.iconeFallback, required this.corFundo, required this.subtitulo, required this.textoLongo});
}

final List<NeuroInfo> neuroDivergencias = [
  NeuroInfo(titulo: 'Autismo', imagemAsset: 'assets/images/autismo.png', iconeFallback: Icons.extension, corFundo: const Color(0xFFFDE8E9), subtitulo: '• Apoiando o Estudante com TEA em Sala de Aula', textoLongo: 'O Transtorno do Espectro Autista (TEA) é uma variação natural do funcionamento neurológico humano, que pode afetar a forma como o aluno absorve informações e interage.\n\nAlunos com TEA possuem capacidades cognitivas na média ou acima dela, mas podem apresentar perfis de aprendizagem irregulares que exigem estratégias específicas.'),
  NeuroInfo(titulo: 'TDAH', imagemAsset: 'assets/images/tdah.png', iconeFallback: Icons.all_inclusive, corFundo: const Color(0xFFF9DDB5), subtitulo: '• Apoiando o Estudante com TDAH em Sala de Aula', textoLongo: 'O TDAH é uma variação natural do funcionamento neurológico que afeta a regulação da atenção, impulsividade e atividade física.\n\nAlunos com TDAH costumam ser fortes multitarefas, altamente criativos e, quando estimulados corretamente, capazes de entrar em um estado de "hiperfoco".'),
  NeuroInfo(titulo: 'Dislexia', imagemAsset: 'assets/images/dislexia.png', iconeFallback: Icons.sort_by_alpha, corFundo: const Color(0xFFEFE8BA), subtitulo: '• Apoiando o Estudante com Dislexia em Sala de Aula', textoLongo: 'A dislexia é uma condição neurodivergente que afeta a forma como as pessoas absorvem e processam informações textuais.\n\nA dislexia não afeta a inteligência de um indivíduo, mas sim as habilidades de decodificação de linguagem. Adaptações visuais e tempo extra são fundamentais.'),
];

class InformativaPage extends StatefulWidget {
  const InformativaPage({super.key});
  @override
  State<InformativaPage> createState() => _InformativaPageState();
}

class _InformativaPageState extends State<InformativaPage> {
  String userName = 'Carregando...', userCargo = '...';
  NeuroInfo? itemSelecionado;

  @override
  void initState() { super.initState(); _carregar(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (mounted) setState(() { userName = dados.nome; userCargo = dados.cargo; });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final w = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (w - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(backgroundColor: c.headerBg, body: SafeArea(bottom: false, child: Stack(children: [
      Column(children: [
        RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 300),
            child: itemSelecionado == null ? _buildLista(c, navH, bottomInset) : _buildDetalhe(c, navH, bottomInset)),
        )),
      ]),
      Positioned(left: (w - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 3, userCargo: userCargo.toLowerCase(), navW: navW))),
    ])));
  }

  Widget _buildLista(dynamic c, double navH, double bottomInset) {
    return ListView(key: const ValueKey('lista'), padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset), children: [
      Text('Informativa', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
      const SizedBox(height: 12),
      Text('Acesse aqui orientações e recursos para apoiar o desenvolvimento de cada estudante.', style: TextStyle(fontSize: 16, color: c.subInk, height: 1.4)),
      const SizedBox(height: 32),
      ...neuroDivergencias.map((info) => GestureDetector(onTap: () => setState(() => itemSelecionado = info),
        child: Container(margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20), decoration: BoxDecoration(color: info.corFundo, borderRadius: BorderRadius.circular(32)),
          child: Column(children: [
            SizedBox(height: 100, child: Image.asset(info.imagemAsset, fit: BoxFit.contain, errorBuilder: (ctx, err, st) => Icon(info.iconeFallback, size: 80, color: c.ink.withAlpha(128)))),
            const SizedBox(height: 16),
            Text(info.titulo, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: c.inkDark)),
          ])))),
    ]);
  }

  Widget _buildDetalhe(dynamic c, double navH, double bottomInset) {
    final info = itemSelecionado!;
    return ListView(key: const ValueKey('detalhe'), padding: EdgeInsets.fromLTRB(24, 24, 24, navH + 16 + bottomInset), children: [
      Container(padding: const EdgeInsets.fromLTRB(24, 40, 24, 24), decoration: BoxDecoration(color: info.corFundo, borderRadius: BorderRadius.circular(32)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 120, child: Image.asset(info.imagemAsset, fit: BoxFit.contain, errorBuilder: (ctx, err, st) => Icon(info.iconeFallback, size: 100, color: c.inkDark.withAlpha(128)))),
          const SizedBox(height: 32),
          Text(info.titulo, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: c.inkDark)),
          const SizedBox(height: 24),
          Text(info.subtitulo, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.inkDark, height: 1.3)),
          const SizedBox(height: 24),
          Text(info.textoLongo, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: c.subInk, height: 1.6)),
          const SizedBox(height: 40),
          Align(alignment: Alignment.centerLeft, child: ElevatedButton(onPressed: () => setState(() => itemSelecionado = null),
            style: ElevatedButton.styleFrom(backgroundColor: c.inkDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            child: const Text('Voltar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))),
        ])),
    ]);
  }
}
