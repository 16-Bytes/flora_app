import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';
import 'questionario.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});
  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  String userName = 'Carregando...';
  String userCargo = '...';
  bool isLoading = true;
  int? avaliacaoPendenteId;
  int? questionarioPendenteId;

  @override
  void initState() { super.initState(); _carregar(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    setState(() { userName = dados.nome; userCargo = dados.cargo; });
    try {
      final res = await ApiService.get('/api/dashboard');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['avaliacoes_pendentes'] != null && data['avaliacoes_pendentes'].isNotEmpty) {
          final p = data['avaliacoes_pendentes'][0];
          if (mounted) setState(() { avaliacaoPendenteId = p['id']; questionarioPendenteId = p['questionario_id']; });
        }
      }
    } catch (e) { debugPrint('Erro: $e'); }
    finally { if (mounted) setState(() => isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(280.0, 400.0);
    const navH = 112.0;
    final temPendente = avaliacaoPendenteId != null && questionarioPendenteId != null;

    return Scaffold(
      backgroundColor: c.headerBg,
      body: SafeArea(bottom: false, child: Stack(children: [
        Column(children: [
          RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: ListView(padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset), children: [
              Text('Formulário', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: c.cardBeige, borderRadius: BorderRadius.circular(24)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pronto para Florescer?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.inkDark)),
                  const SizedBox(height: 16),
                  Text('Olá! Queremos conhecer melhor o seu perfil para tornar a escola um lugar mais acolhedor.', style: TextStyle(fontSize: 14, color: c.inkDark, height: 1.5)),
                  const SizedBox(height: 16),
                  Text('Dicas rápidas:', style: TextStyle(fontSize: 14, color: c.inkDark, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  _bullet(context, 'Sinceridade: Não há respostas certas ou erradas.'),
                  const SizedBox(height: 4),
                  _bullet(context, 'Escala: Use de 1 a 5 para responder.'),
                  const SizedBox(height: 16),
                  if (isLoading)
                    Center(child: CircularProgressIndicator(color: c.inkDark))
                  else if (!temPendente)
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.surfaceCard.withAlpha(128), borderRadius: BorderRadius.circular(12)), child: Text('Você não tem formulários pendentes no momento! 🎉', style: TextStyle(color: c.inkDark, fontWeight: FontWeight.w600)))
                  else ...[
                    Text('Podemos iniciar?', style: TextStyle(fontSize: 14, color: c.inkDark, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    Center(child: SizedBox(width: 180, height: 45, child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionarioPage(avaliacaoId: avaliacaoPendenteId!, questionarioId: questionarioPendenteId!))),
                      style: ElevatedButton.styleFrom(backgroundColor: c.btnSecondary, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))),
                      icon: const Icon(Icons.play_arrow_outlined, size: 20),
                      label: const Text('Iniciar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    ))),
                  ],
                ]),
              ),
            ]),
          )),
        ]),
        Positioned(left: (size.width - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 1, userCargo: userCargo, navW: navW))),
      ])),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    final c = context.colors;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(top: 6, right: 8, left: 4), child: Icon(Icons.circle, size: 6, color: c.inkDark)),
      Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: c.inkDark, height: 1.5))),
    ]);
  }
}
