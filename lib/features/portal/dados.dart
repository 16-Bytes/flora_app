import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/helpers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_ext.dart';
import '../../shared/widgets/menu_inferior.dart';
import '../../shared/widgets/shared_header.dart';

class DadosPage extends StatefulWidget {
  const DadosPage({super.key});
  @override
  State<DadosPage> createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage> {
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
          child: ListView(padding: EdgeInsets.fromLTRB(23, 26, 23, navH + 16 + bottomInset), children: [
            Text('Dados', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: c.inkDark)),
            const SizedBox(height: 24),

            // Stat cards
            Row(children: [
              Expanded(child: _StatMini(label: 'Testes solicitados:', value: '0', bg: c.statYellowBg, txt: c.statYellowTxt)),
              const SizedBox(width: 16),
              Expanded(child: _StatMini(label: 'Testes pendentes:', value: '0', bg: c.quickCardBg, txt: c.quickTxt)),
            ]),
            const SizedBox(height: 24),

            // Bar chart — Semestre
            RepaintBoundary(child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: c.chartBg, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Semestre:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.inkDark)),
                const SizedBox(height: 20),
                SizedBox(height: 200, child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 5, getTitlesWidget: (v, meta) => Text(v.toInt().toString(), style: TextStyle(color: c.subInkLight, fontSize: 10)))),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                      const meses = ['Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul'];
                      return Padding(padding: const EdgeInsets.only(top: 8), child: Text(v.toInt() < meses.length ? meses[v.toInt()] : '', style: TextStyle(color: c.subInk, fontSize: 10)));
                    })),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 5, getDrawingHorizontalLine: (v) => FlLine(color: c.borderCard, strokeWidth: 0.5)),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _bar(0, 10, c.chartBarColor), _bar(1, 13, c.chartBarColor), _bar(2, 7, c.chartBarColor),
                    _bar(3, 15, c.chartBarColor), _bar(4, 11, c.chartBarColor), _bar(5, 17, c.chartBarColor),
                  ],
                ))),
              ]),
            )),
            const SizedBox(height: 24),

            // Pie chart — Visão Geral dos Resultados
            RepaintBoundary(child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: c.pieBg, borderRadius: BorderRadius.circular(24)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Visão Geral dos\nResultados:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: c.inkDark)),
                const SizedBox(height: 20),
                SizedBox(height: 220, child: PieChart(PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  sections: [
                    PieChartSectionData(value: 55, color: c.chartBg, radius: 60, title: 'TEA\n55%', titleStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c.inkDark)),
                    PieChartSectionData(value: 25, color: c.statYellowBg, radius: 60, title: 'TDAH\n25%', titleStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c.inkDark)),
                    PieChartSectionData(value: 15, color: c.chartBarColor, radius: 60, title: 'TEA e\nTDAH\n15%', titleStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: c.inkDark)),
                    PieChartSectionData(value: 5, color: c.quickCardBg, radius: 60, title: 'Neg.\n5%', titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c.inkDark)),
                  ],
                ))),
              ]),
            )),
          ]),
        )),
      ]),
      Positioned(left: (size.width - navW) / 2, bottom: 8 + bottomInset, child: RepaintBoundary(child: SharedBottomNav(currentIndex: 3, userCargo: userCargo, navW: navW))),
    ])));
  }

  BarChartGroupData _bar(int x, double y, Color color) => BarChartGroupData(x: x, barRods: [BarChartRodData(toY: y, color: color, width: 22, borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)))]);
}

class _StatMini extends StatelessWidget {
  final String label, value;
  final Color bg, txt;
  const _StatMini({required this.label, required this.value, required this.bg, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24), boxShadow: const [AppColors.cardShadow]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label, style: TextStyle(fontSize: 13, color: txt, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        const SizedBox(height: 0),
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: txt)),
      ]),
    );
  }
}
