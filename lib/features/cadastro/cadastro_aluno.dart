import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/formatters/cpf_formatter.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class CadastroAlunoPage extends StatefulWidget {
  const CadastroAlunoPage({super.key});
  @override
  State<CadastroAlunoPage> createState() => _CadastroAlunoPageState();
}

class _CadastroAlunoPageState extends State<CadastroAlunoPage> {
  String userName = 'Carregando...', userCargo = '...';
  bool isLoading = false;
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _turmaCtrl = TextEditingController();
  final _respNomeCtrl = TextEditingController();
  final _respEmailCtrl = TextEditingController();
  final _respCpfCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _carregar(); }

  @override
  void dispose() {
    _nomeCtrl.dispose(); _emailCtrl.dispose(); _cpfCtrl.dispose(); _turmaCtrl.dispose();
    _respNomeCtrl.dispose(); _respEmailCtrl.dispose(); _respCpfCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (mounted) setState(() { userName = dados.nome; userCargo = dados.cargo; });
  }

  Future<void> _enviar() async {
    if (_nomeCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _cpfCtrl.text.isEmpty || _turmaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos obrigatórios.')));
      return;
    }
    setState(() => isLoading = true);
    try {
      final res = await ApiService.post('/api/cadastrar-aluno', body: {
        'nome': _nomeCtrl.text, 'email': _emailCtrl.text, 'cpf': _cpfCtrl.text, 'turma': _turmaCtrl.text,
        'responsavel': { 'nome': _respNomeCtrl.text, 'email': _respEmailCtrl.text, 'cpf': _respCpfCtrl.text },
      });
      if (mounted) {
        if (res.statusCode == 200 || res.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aluno cadastrado com sucesso!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao cadastrar aluno.')));
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
            Text('Cadastro do Aluno', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
            const SizedBox(height: 24),

            // Card Informações do Aluno
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.cadastroAlunoBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: c.cadastroAlunoBorder.withAlpha(60))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ElevatedButton.icon(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: c.btnPrimary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.arrow_back, size: 16), label: const Text('Voltar')),
                const SizedBox(height: 20),
                Text('Informações do Aluno:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.inkDark)),
                const SizedBox(height: 16),
                _CadastroField(label: 'Nome completo', hint: 'Ex: João Pedro da Silva', controller: _nomeCtrl, required_: true, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words),
                _CadastroField(label: 'Email', hint: 'Ex: aluno@gmail.com', controller: _emailCtrl, required_: true, keyboardType: TextInputType.emailAddress),
                _CadastroField(label: 'CPF', hint: 'Ex: 123.456.789-10', controller: _cpfCtrl, required_: true, keyboardType: TextInputType.number, formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')), CpfInputFormatter()]),
                _CadastroField(label: 'Turma', hint: 'Ex: 996', controller: _turmaCtrl, required_: true, keyboardType: TextInputType.number, formatters: [FilteringTextInputFormatter.digitsOnly]),
                const SizedBox(height: 8),
                Text('Foto de perfil*', style: TextStyle(color: c.inkDark, fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Container(height: 80, width: double.infinity, decoration: BoxDecoration(color: c.inputBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.inputBorder)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.cloud_upload_outlined, size: 28, color: c.subInkLight),
                    const SizedBox(height: 4),
                    Text('Arraste seu arquivo aqui', style: TextStyle(color: c.subInkLight, fontSize: 12)),
                  ])),
              ])),
            const SizedBox(height: 20),

            // Card Informações do Responsável
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.cadastroAlunoBg, borderRadius: BorderRadius.circular(24), border: Border.all(color: c.cadastroAlunoBorder.withAlpha(60))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Informações do responsável:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.inkDark)),
                const SizedBox(height: 16),
                _CadastroField(label: 'Nome completo', hint: 'Ex: João Pedro da Silva', controller: _respNomeCtrl, required_: true, keyboardType: TextInputType.name, textCapitalization: TextCapitalization.words),
                _CadastroField(label: 'Email', hint: 'Ex: responsavel@gmail.com', controller: _respEmailCtrl, required_: true, keyboardType: TextInputType.emailAddress),
                _CadastroField(label: 'CPF', hint: 'Ex: 123.456.789-10', controller: _respCpfCtrl, required_: true, keyboardType: TextInputType.number, formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')), CpfInputFormatter()]),
              ])),
            const SizedBox(height: 24),

            // Botão Enviar
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

class _CadastroField extends StatelessWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool required_;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? formatters;
  final TextCapitalization textCapitalization;

  const _CadastroField({
    required this.label,
    required this.hint,
    required this.controller,
    this.required_ = false,
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
        if (required_) const TextSpan(text: '*', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 14)),
      ])),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(color: c.inputBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.inputBorder)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: formatters,
          textCapitalization: textCapitalization,
          style: TextStyle(color: c.ink, fontSize: 14),
          decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: c.subInkLight, fontSize: 13), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
        ),
      ),
    ]));
  }
}
