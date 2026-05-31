import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';
import '../portal/dashboard.dart';

class QuestionarioPage extends StatefulWidget {
  final int avaliacaoId;
  final int questionarioId;
  const QuestionarioPage({super.key, required this.avaliacaoId, required this.questionarioId});
  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  String userName = 'Carregando...';
  String userCargo = '...';
  bool isLoading = true, isSubmitting = false, formConcluido = false;
  String? errorMessage;
  List<dynamic> perguntas = [];
  Map<int, int> respostas = {};
  int currentPage = 0;
  final int perguntasPorPagina = 3;
  final List<String> opcoesTexto = ['Nem um\npouco', 'Só um\npouco', 'Bastante', 'Demais'];

  @override
  void initState() { super.initState(); _carregar(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    setState(() { userName = dados.nome; userCargo = dados.cargo; });
    try {
      final res = await ApiService.get('/api/questionario/${widget.questionarioId}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) setState(() => perguntas = data['perguntas']);
      } else { if (mounted) setState(() => errorMessage = 'Erro ao carregar o formulário.'); }
    } catch (e) { if (mounted) setState(() => errorMessage = 'Sem conexão com a internet.'); }
    finally { if (mounted) setState(() => isLoading = false); }
  }

  Future<void> _enviar() async {
    setState(() => isSubmitting = true);
    try {
      final res = await ApiService.post('/api/avaliacoes/responder', body: {
        'avaliacao_id': widget.avaliacaoId,
        'respostas': respostas.map((k, v) => MapEntry(k.toString(), v)),
      });
      if (res.statusCode == 200) { if (mounted) setState(() => formConcluido = true); }
      else { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao salvar.'))); }
    } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro de conexão.'))); }
    finally { if (mounted) setState(() => isSubmitting = false); }
  }

  void _avancar() {
    int totalPages = (perguntas.length / perguntasPorPagina).ceil();
    int s = currentPage * perguntasPorPagina;
    int e = (s + perguntasPorPagina > perguntas.length) ? perguntas.length : s + perguntasPorPagina;
    for (int i = s; i < e; i++) { if (!respostas.containsKey(perguntas[i]['id'])) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Responda todas as perguntas.'), backgroundColor: Colors.red)); return; } }
    if (currentPage >= totalPages - 1) { _enviar(); } else { setState(() => currentPage++); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(
      backgroundColor: c.headerBg,
      body: SafeArea(bottom: false, child: Stack(children: [
        Column(children: [
          RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: isLoading ? Center(child: CircularProgressIndicator(color: c.ink))
                : errorMessage != null ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
                : formConcluido ? _buildSucesso(c)
                : _buildConteudo(c, navH, bottomInset),
          )),
        ]),
        if (!formConcluido) Positioned(left: (size.width - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 1, userCargo: userCargo, navW: navW))),
      ])),
    );
  }

  Widget _buildConteudo(dynamic c, double navH, double bottomInset) {
    int totalPages = (perguntas.length / perguntasPorPagina).ceil();
    int s = currentPage * perguntasPorPagina;
    int e = (s + perguntasPorPagina > perguntas.length) ? perguntas.length : s + perguntasPorPagina;
    var atual = perguntas.sublist(s, e);
    double progresso = totalPages > 0 ? (currentPage + 1) / totalPages : 0;

    return ListView(padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset), children: [
      Text('Formulário', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
      const SizedBox(height: 12),
      ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progresso, minHeight: 10, backgroundColor: c.progressBg, valueColor: AlwaysStoppedAnimation<Color>(c.progressFill))),
      const SizedBox(height: 24),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: c.cardBeige, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Querido Aluno(a):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c.inkDark)),
        const SizedBox(height: 20),
        ...atual.map((p) => _buildPergunta(c, p)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: c.btnSecondary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), elevation: 0), icon: const Icon(Icons.logout, size: 18), label: const Text('Sair'))),
          const SizedBox(width: 12),
          Expanded(child: ElevatedButton(onPressed: isSubmitting ? null : _avancar, style: ElevatedButton.styleFrom(backgroundColor: c.btnSecondary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), elevation: 0),
            child: isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(currentPage >= (perguntas.length / perguntasPorPagina).ceil() - 1 ? 'Concluir' : 'Próximo'),
                    const SizedBox(width: 8),
                    Icon(currentPage >= (perguntas.length / perguntasPorPagina).ceil() - 1 ? Icons.check : Icons.arrow_forward, size: 18),
                  ]),
          )),
        ]),
      ])),
    ]);
  }

  Widget _buildPergunta(dynamic c, dynamic pergunta) {
    return Padding(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(pergunta['texto'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.inkDark, height: 1.4)),
      const SizedBox(height: 16),
      Row(children: List.generate(4, (index) {
        int val = index + 1;
        bool sel = respostas[pergunta['id']] == val;
        return Expanded(child: Padding(padding: EdgeInsets.only(right: index < 3 ? 6.0 : 0), child: InkWell(
          onTap: () => setState(() => respostas[pergunta['id']] = val),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: sel ? c.btnSecondary : c.surfaceCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? c.btnSecondary : c.borderLight)),
            child: Text(opcoesTexto[index], textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: sel ? FontWeight.bold : FontWeight.w500, color: sel ? Colors.white : c.inkDark, height: 1.2)),
          ),
        )));
      })),
    ]));
  }

  Widget _buildSucesso(dynamic c) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: c.successGreen, width: 8)), child: Icon(Icons.check, size: 80, color: c.successGreen)),
      const SizedBox(height: 40),
      Text('Formulário concluído com sucesso!!', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.successGreen)),
      const SizedBox(height: 48),
      ElevatedButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashboardPage()), (route) => false),
        style: ElevatedButton.styleFrom(backgroundColor: c.ink, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), elevation: 0),
        child: const Text('Voltar ao painel de controle', style: TextStyle(fontSize: 15))),
    ]);
  }
}
