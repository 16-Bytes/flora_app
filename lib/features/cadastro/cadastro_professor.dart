import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/formatters/cpf_formatter.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class CadastroProfessorPage extends StatefulWidget {
  const CadastroProfessorPage({super.key});
  @override
  State<CadastroProfessorPage> createState() => _CadastroProfessorPageState();
}

class _CadastroProfessorPageState extends State<CadastroProfessorPage> {
  String userName = 'Carregando...', userCargo = '...';
  bool isLoading = false;
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _turmasCtrl = TextEditingController();
  final _tempoCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _carregar(); }

  @override
  void dispose() {
    _nomeCtrl.dispose(); _emailCtrl.dispose(); _cpfCtrl.dispose();
    _turmasCtrl.dispose(); _tempoCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (mounted) setState(() { userName = dados.nome; userCargo = dados.cargo; });
  }

  Future<void> _enviar() async {
    if (_nomeCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _cpfCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos obrigatórios.')));
      return;
    }
    setState(() => isLoading = true);
    try {
      final res = await ApiService.post('/api/cadastrar-professor', body: {
        'nome_completo': _nomeCtrl.text, 'email': _emailCtrl.text, 'cpf': _cpfCtrl.text,
        'turmas': _turmasCtrl.text, 'tempo_semanal': _tempoCtrl.text,
      });
      if (mounted) {
        if (res.statusCode == 200 || res.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Professor cadastrado com sucesso!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao cadastrar professor.')));
        }
      }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro de conexão.'))); }
    finally { if (mounted) setState(() => isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: c.headerBg, body: SafeArea(bottom: false, child: Stack(children: [
      Column(children: [
        RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
        Expanded(child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset), children: [
            Text('Cadastro do Professor', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
            const SizedBox(height: 24),

            // Card dados pessoais (fundo rosa)
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.cadastroProfBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: c.cadastroProfBorder.withAlpha(60))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ElevatedButton.icon(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: c.btnPrimary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.arrow_back, size: 16), label: const Text('Voltar')),
                const SizedBox(height: 20),
                _Field(label: 'Nome completo do professor', hint: 'Ex: João Pedro da Silva', controller: _nomeCtrl, req: true, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words),
                _Field(label: 'Email', hint: 'Ex: professor@gmail.com', controller: _emailCtrl, req: true, keyboardType: TextInputType.emailAddress),
                _Field(label: 'CPF', hint: 'Ex: 123.456.789-10', controller: _cpfCtrl, req: true, keyboardType: TextInputType.number, formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')), CpfInputFormatter()]),
              ])),
            const SizedBox(height: 20),

            // Card turmas (fundo verde)
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.cadastroAlunoBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: c.cadastroAlunoBorder.withAlpha(60))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _Field(label: 'Turmas', hint: 'Ex: 683,678,684', controller: _turmasCtrl, req: true),
                _Field(label: 'Tempo semanal por turma', hint: 'Ex: 2 tempos', controller: _tempoCtrl, req: true),
              ])),
            const SizedBox(height: 24),

            SizedBox(height: 52, child: ElevatedButton.icon(
              onPressed: isLoading ? null : _enviar,
              style: ElevatedButton.styleFrom(backgroundColor: c.btnAction, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send, size: 18),
              label: const Text('Enviar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )),
          ]),
        )),
      ]),
      Positioned(left: (size.width - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: -1, userCargo: userCargo, navW: navW))),
    ])));
  }
}

class _Field extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool req;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final TextCapitalization textCapitalization;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.req = false,
    this.keyboardType,
    this.formatters,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RichText(text: TextSpan(children: [
        TextSpan(text: label, style: TextStyle(color: c.inkDark, fontWeight: FontWeight.w600, fontSize: 14)),
        if (req) const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 14)),
      ])),
      const SizedBox(height: 8),
      Container(decoration: BoxDecoration(color: c.inputBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.inputBorder)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: formatters,
          textCapitalization: textCapitalization,
          style: TextStyle(color: c.ink, fontSize: 14),
          decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: c.subInkLight, fontSize: 13), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        )),
    ]));
  }
}
