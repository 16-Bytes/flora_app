import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/helpers.dart';
import '../../core/services/api_service.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class Prof { final String nome, disciplina, status; Prof(this.nome, this.disciplina, this.status); }

class ProfessorPage extends StatefulWidget {
  const ProfessorPage({super.key});
  @override
  State<ProfessorPage> createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  String userName = 'Carregando...', userCargo = '...';
  bool isLoading = true;
  List<Prof> todos = [], filtrados = [];
  final _searchCtrl = TextEditingController();

  @override
  void initState() { super.initState(); _carregar(); }
  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  Future<void> _carregar() async {
    final dados = await carregarDadosUsuario();
    if (!mounted) return;
    setState(() { userName = dados.nome; userCargo = dados.cargo; });
    try {
      final res = await ApiService.get('/api/professores');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List<dynamic> json = data['professores'] ?? [];
        if (mounted) {
          setState(() {
            todos = json.asMap().entries.map((e) {
              String s = 'Verificado';
              if (e.key % 3 == 0) { s = 'Pendente'; } else if (e.key % 3 == 1) { s = 'Entregue'; }
              return Prof(e.value['nome_completo'] ?? 'Sem Nome', e.value['disciplina_principal'] ?? 'Multidisciplinar', s);
            }).toList();
            filtrados = List.from(todos);
          });
        }
      }
    } catch (e) { debugPrint('Erro: $e'); }
    finally { if (mounted) setState(() => isLoading = false); }
  }

  void _filtrar(String q) {
    final ql = q.toLowerCase();
    setState(() {
      filtrados = todos.where((p) => p.nome.toLowerCase().contains(ql) || p.disciplina.toLowerCase().contains(ql)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final w = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (w - 24).clamp(280.0, 400.0);
    const navH = 112.0;

    return Scaffold(resizeToAvoidBottomInset: false, backgroundColor: c.headerBg, body: SafeArea(bottom: false, child: Stack(children: [
      Column(children: [
        RepaintBoundary(child: SharedHeader(userName: userName, userCargo: userCargo)),
        Expanded(child: Container(
          decoration: BoxDecoration(color: c.surface, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: isLoading ? Center(child: CircularProgressIndicator(color: c.ink))
              : ListView(padding: EdgeInsets.fromLTRB(23, 26, 23, navH + bottomInset), children: [
                  Text('Professores', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
                  const SizedBox(height: 18),
                  Container(height: 52, decoration: BoxDecoration(color: c.surfaceCard, border: Border.all(color: c.borderCard), borderRadius: BorderRadius.circular(999)), padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [Icon(Icons.search, size: 18, color: c.subInkLight), const SizedBox(width: 12), Expanded(child: TextField(controller: _searchCtrl, onChanged: _filtrar, decoration: InputDecoration(border: InputBorder.none, hintText: 'Buscar professores...', hintStyle: TextStyle(color: c.subInkLight)), style: TextStyle(fontSize: 16, color: c.ink)))])),
                  const SizedBox(height: 16),
                  Row(children: ['Nome', 'Matéria', 'Status'].map((f) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: c.filterBg, borderRadius: BorderRadius.circular(999), border: Border.all(color: c.borderFilter)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.filter_list, size: 12, color: c.filterTxt), const SizedBox(width: 4), Text(f, style: TextStyle(color: c.filterTxt, fontWeight: FontWeight.w600, fontSize: 12))]))).toList()),
                  const SizedBox(height: 20),
                  if (filtrados.isEmpty) Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Nenhum professor encontrado.', style: TextStyle(color: c.subInkLight))))
                  else ...filtrados.map((p) => _buildCard(c, p)),
                ]),
        )),
      ]),
      Positioned(left: (w - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 2, userCargo: userCargo, navW: navW))),
    ])));
  }

  Widget _buildCard(dynamic c, Prof p) {
    Color sBg, sTxt; bool isPend = p.status == 'Pendente';
    switch (p.status) { case 'Pendente': sBg = c.statusPendenteBg; sTxt = c.statusPendenteTxt; case 'Entregue': sBg = c.statusEntregueBg; sTxt = c.statusEntregueTxt; default: sBg = c.statusVerificadoBg; sTxt = c.statusVerificadoTxt; }
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: c.surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: c.borderCard)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: c.filterBg, borderRadius: BorderRadius.circular(999)), child: Icon(Icons.person_outline, color: c.subInkLight)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.nome, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: c.inkDark), maxLines: 1, overflow: TextOverflow.ellipsis), Text(p.disciplina, style: TextStyle(fontSize: 13, color: c.subInkLight))])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: sBg, borderRadius: BorderRadius.circular(12)), child: Text(p.status, style: TextStyle(fontSize: 12, color: sTxt, fontWeight: FontWeight.w600))),
        ]),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: c.borderCard, height: 1)),
        Row(children: [
          Expanded(child: ElevatedButton.icon(icon: Icon(Icons.remove_red_eye_outlined, size: 18, color: isPend ? c.subInkLight : Colors.white), label: Text('Visualizar relatório', style: TextStyle(color: isPend ? c.subInkLight : Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: isPend ? c.filterBg : c.btnAction, elevation: 0, minimumSize: const Size(0, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: isPend ? null : () {})),
          const SizedBox(width: 8),
          ElevatedButton.icon(icon: Icon(Icons.edit_outlined, color: c.btnAction, size: 18), label: Text('Editar', style: TextStyle(color: c.btnAction)),
            style: ElevatedButton.styleFrom(backgroundColor: c.surfaceCard, elevation: 0, minimumSize: const Size(0, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: c.borderFilter))), onPressed: () {}),
        ]),
      ]));
  }
}
