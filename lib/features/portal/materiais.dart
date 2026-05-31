import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class Disciplina {
  final String nome, professor, turma;
  final Color corFundo, corTexto;
  final IconData icone;
  Disciplina(this.nome, this.professor, this.turma, this.corFundo, this.corTexto, this.icone);
}

class Documento { final String titulo; bool isSelecionado; Documento(this.titulo, {this.isSelecionado = false}); }
class Mensagem { final String texto; final bool isUser; Mensagem(this.texto, {this.isUser = false}); }

final List<Disciplina> mockDisciplinas = [
  Disciplina('História', 'Mariana Souza', '996', const Color(0xFFE8F5F2), const Color(0xFF5A9B8A), Icons.history_edu),
  Disciplina('Projeto de vida', 'Carlos Eduardo Lima', '996', const Color(0xFFFCE6D2), const Color(0xFFC4864D), Icons.volunteer_activism),
  Disciplina('Sociologia', 'Felipe Andrade Moura', '996', const Color(0xFFF8F4E6), const Color(0xFF988E6D), Icons.groups_outlined),
  Disciplina('Matemática', 'Ana Paula Mendes', '996', const Color(0xFFFBE8E9), const Color(0xFFB15C5E), Icons.square_foot),
];

class MateriaisPage extends StatefulWidget {
  const MateriaisPage({super.key});
  @override
  State<MateriaisPage> createState() => _MateriaisPageState();
}

class _MateriaisPageState extends State<MateriaisPage> {
  String userName = 'Carregando...', userCargo = '...';
  Disciplina? disciplinaSelecionada;
  final _searchController = TextEditingController();
  final _chatController = TextEditingController();
  List<Documento> fontesAtivas = [];
  List<Mensagem> chatHistory = [Mensagem('Olá! Anexe um material em PDF ou faça sua pergunta diretamente.', isUser: false)];
  String? _sessaoId, materialIdAtual;
  bool isDigitando = false;

  @override
  void initState() { super.initState(); _carregar(); }
  @override
  void dispose() { _searchController.dispose(); _chatController.dispose(); super.dispose(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    _sessaoId = 'sessao_${dados.token.hashCode.abs()}';
    setState(() { userName = dados.nome; userCargo = dados.cargo; });
  }

  Future<void> _anexarDocumento() async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result == null || result.files.single.path == null) return;
    File arquivoPdf = File(result.files.single.path!);
    String nomeArquivo = result.files.single.name;
    setState(() { chatHistory.add(Mensagem('Anexando material: $nomeArquivo...', isUser: false)); isDigitando = true; });
    try {
      var response = await ApiService.uploadFlorAI('/api/upload', filePath: arquivoPdf.path, fieldName: 'pdf');
      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final data = jsonDecode(responseString);
        if (mounted) setState(() { materialIdAtual = data['materialId'].toString(); fontesAtivas.add(Documento(nomeArquivo, isSelecionado: true)); chatHistory.removeLast(); chatHistory.add(Mensagem('✅ Material "$nomeArquivo" processado com sucesso!', isUser: false)); });
      } else { throw Exception('Erro na API'); }
    } catch (e) { if (mounted) setState(() { chatHistory.removeLast(); chatHistory.add(Mensagem('❌ Falha ao processar o PDF.', isUser: false)); }); }
    finally { if (mounted) setState(() => isDigitando = false); }
  }

  Future<void> _enviarMensagem() async {
    if (_chatController.text.isEmpty) return;
    String pergunta = _chatController.text;
    _chatController.clear();
    setState(() { chatHistory.add(Mensagem(pergunta, isUser: true)); isDigitando = true; });
    try {
      final response = await ApiService.postFlorAI('/api/chat', body: {'sessaoId': _sessaoId, 'mensagem': pergunta, if (materialIdAtual != null) 'materialId': materialIdAtual});
      if (response.statusCode == 200) { final data = jsonDecode(response.body); if (mounted) setState(() => chatHistory.add(Mensagem(data['resposta'], isUser: false))); }
      else { throw Exception('Erro ${response.statusCode}'); }
    } catch (e) { if (mounted) setState(() => chatHistory.add(Mensagem('Desculpe, estou com dificuldade de me conectar.', isUser: false))); }
    finally { if (mounted) setState(() => isDigitando = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final w = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final navW = (w - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: c.headerBg, body: SafeArea(bottom: false, child: Stack(children: [
      Column(children: [
        RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: AnimatedSwitcher(duration: const Duration(milliseconds: 250),
            child: disciplinaSelecionada == null
                ? _buildListaMateriais(c, keyboardOpen ? 24.0 : navH, bottomInset)
                : _buildChatView(c, keyboardOpen ? keyboardHeight : navH, bottomInset, keyboardOpen)),
        )),
      ]),
      if (disciplinaSelecionada != null) _buildFloatingChatInput(c, w, keyboardOpen ? keyboardHeight : navH, bottomInset, keyboardOpen),
      if (!keyboardOpen)
        Positioned(left: (w - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 2, userCargo: userCargo, navW: navW))),
    ])));
  }

  Widget _buildListaMateriais(dynamic c, double navH, double bottomInset) {
    return ListView(key: const ValueKey('list'), padding: EdgeInsets.fromLTRB(23, 26, 23, navH + 16 + bottomInset), children: [
      Text('Materiais', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
      const SizedBox(height: 10),
      Text('Acesse os materiais das suas disciplinas.', style: TextStyle(fontSize: 16, color: c.subInk)),
      const SizedBox(height: 18),
      Container(height: 52, decoration: BoxDecoration(color: c.surfaceCard, borderRadius: BorderRadius.circular(999), border: Border.all(color: c.borderLight)), padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [Icon(Icons.search, size: 18, color: c.subInkLight), const SizedBox(width: 12), Expanded(child: TextField(controller: _searchController, decoration: InputDecoration(hintText: 'Buscar turmas...', border: InputBorder.none, hintStyle: TextStyle(color: c.borderLight)), style: TextStyle(fontSize: 16, color: c.ink)))])),
      const SizedBox(height: 22),
      ...mockDisciplinas.map((d) => _buildDisciplinaCard(d)),
    ]);
  }

  Widget _buildDisciplinaCard(Disciplina disc) {
    return GestureDetector(onTap: () => setState(() => disciplinaSelecionada = disc), child: Container(
      margin: const EdgeInsets.only(bottom: 16), height: 115,
      decoration: BoxDecoration(color: disc.corFundo, borderRadius: BorderRadius.circular(32), boxShadow: const [AppColors.cardShadow]),
      child: Stack(children: [
        Positioned(right: -10, bottom: -15, child: Icon(disc.icone, size: 140, color: disc.corTexto.withAlpha(25))),
        Padding(padding: const EdgeInsets.all(24), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(disc.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: disc.corTexto)),
            const SizedBox(height: 4),
            Text(disc.professor, style: TextStyle(fontSize: 13, color: disc.corTexto.withAlpha(178))),
          ])),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Turma:', style: TextStyle(fontSize: 10, color: disc.corTexto.withAlpha(178))),
            const SizedBox(height: 2),
            Text(disc.turma, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: disc.corTexto)),
          ]),
        ])),
      ]),
    ));
  }

  Widget _buildChatView(dynamic c, double navH, double bottomInset, bool keyboardOpen) {
    return ListView(key: const ValueKey('chat'), padding: EdgeInsets.fromLTRB(23, 26, 23, (keyboardOpen ? navH + 80 : navH + 140) + bottomInset), children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('FlorAI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
        SizedBox(height: 37, child: ElevatedButton.icon(
          onPressed: () => setState(() => disciplinaSelecionada = null),
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
          label: const Text('Voltar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11)),
          style: ElevatedButton.styleFrom(backgroundColor: c.inkDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)), elevation: 0),
        )),
      ]),
      const SizedBox(height: 18),
      if (fontesAtivas.isNotEmpty) ...[_buildFontesBox(c), const SizedBox(height: 22)],
      Row(children: [Icon(Icons.auto_awesome, color: c.statusEntregueTxt, size: 18), const SizedBox(width: 8), Text('FlorAI', style: TextStyle(fontWeight: FontWeight.w600, color: c.statusEntregueTxt, fontSize: 14))]),
      const SizedBox(height: 16),
      ...chatHistory.map((m) => Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: m.isUser ? c.statGreenBg : c.beigeBox, borderRadius: BorderRadius.circular(20)),
        child: Text(m.texto, style: TextStyle(color: c.subInk, height: 1.5, fontSize: 14)),
      )),
      if (isDigitando) Padding(padding: const EdgeInsets.only(top: 8, left: 16), child: Text('FlorAI está pensando...', style: TextStyle(color: c.subInkLight, fontStyle: FontStyle.italic))),
    ]);
  }

  Widget _buildFloatingChatInput(dynamic c, double w, double navH, double bottomInset, bool keyboardOpen) {
    return Positioned(left: 23, right: 23, bottom: (keyboardOpen ? 8 : navH + 20) + bottomInset, child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        _buildFloatBtn(c, 'Anexar', Icons.attach_file, false, _anexarDocumento),
        const SizedBox(width: 10),
        _buildFloatBtn(c, 'Enviar', Icons.send, true, _enviarMensagem),
      ]),
      const SizedBox(height: 12),
      Container(height: 52, decoration: BoxDecoration(color: c.surfaceCard, borderRadius: BorderRadius.circular(999), border: Border.all(color: c.borderLight)), padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(controller: _chatController, decoration: InputDecoration(hintText: 'Qual a sua dúvida?', border: InputBorder.none, hintStyle: TextStyle(color: c.borderLight)), style: TextStyle(fontSize: 16, color: c.ink), onSubmitted: (_) => _enviarMensagem())),
    ]));
  }

  Widget _buildFontesBox(dynamic c) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.beigeBox, borderRadius: BorderRadius.circular(24)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(Icons.menu_book, color: c.quickTxt, size: 18), const SizedBox(width: 8), Text('Fontes ativas:', style: TextStyle(fontWeight: FontWeight.w600, color: c.quickTxt, fontSize: 14))]),
        const SizedBox(height: 16),
        ...fontesAtivas.map((f) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.surfaceCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.borderCard)),
          child: Row(children: [Icon(Icons.picture_as_pdf, size: 20, color: Colors.red[400]), const SizedBox(width: 10), Expanded(child: Text(f.titulo, style: TextStyle(color: c.subInk, fontSize: 13))), Icon(Icons.check_circle, color: c.quickTxt, size: 16)]))),
      ]));
  }

  Widget _buildFloatBtn(dynamic c, String label, IconData icon, bool primary, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(height: 38, decoration: BoxDecoration(color: primary ? c.btnAction : c.surfaceCard, borderRadius: BorderRadius.circular(16), border: primary ? null : Border.all(color: c.borderLight)), padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(children: [Icon(icon, size: 16, color: primary ? Colors.white : c.subInkLight), const SizedBox(width: 6), Text(label, style: TextStyle(color: primary ? Colors.white : c.subInkLight, fontSize: 12, fontWeight: FontWeight.w600))])));
  }
}
