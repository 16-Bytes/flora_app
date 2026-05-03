import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'configuracoes.dart';
import 'shared_bottom_nav.dart';

class QuestionarioPage extends StatefulWidget {
  final int avaliacaoId;
  final int questionarioId;

  const QuestionarioPage({
    super.key,
    required this.avaliacaoId,
    required this.questionarioId,
  });

  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  static const headerBg = Color(0xFF97C2C1);
  static const surface = Color(0xFFFEF9F2);
  static const ink = Color(0xFF304F55);
  static const inkDark = Color(0xFF233B3E);
  static const cardBg = Color(0xFFE8E0B0);
  static const successGreen = Color(0xFF5F8D4E); // Verde dE sucesso msm

  String userName = 'Carregando...';
  String userCargo = '...';

  bool isLoading = true;
  bool isSubmitting = false;

  // ---> A MACUMBA DA TELA NOVA AQUI FUNCIONAAAAAA
  bool formConcluido = false;

  String? errorMessage;

  List<dynamic> perguntas = [];
  Map<int, int> respostas = {};

  int currentPage = 0;
  final int perguntasPorPagina = 3;

  final List<String> opcoesTexto = [
    'Nem um\npouco',
    'Só um\npouco',
    'Bastante',
    'Demais',
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    setState(() {
      userName = prefs.getString('usuario_nome') ?? 'Usuário';
      userCargo = (prefs.getString('usuario_cargo') ?? 'aluno').toUpperCase();
    });

    try {
      final res = await http.get(
        Uri.parse(
          'http://168.75.73.9/api/questionario/${widget.questionarioId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          perguntas = data['perguntas'];
        });
      } else {
        setState(() => errorMessage = "Erro ao carregar o formulário.");
      }
    } catch (e) {
      setState(() => errorMessage = "Sem conexão com a internet.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _enviarRespostas() async {
    setState(() => isSubmitting = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    try {
      final res = await http.post(
        Uri.parse('http://168.75.73.9/api/avaliacoes/responder'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'avaliacao_id': widget.avaliacaoId,
          'respostas': respostas.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        }),
      );

      if (res.statusCode == 200) {
        if (mounted) {
          // Em vez de abrir um Pop-up (Dialog), a gente muda a tela inteira! <3
          setState(() {
            formConcluido = true;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar no servidor.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro de conexão.')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _avancarPagina() {
    int totalPages = (perguntas.length / perguntasPorPagina).ceil();

    int startIndex = currentPage * perguntasPorPagina;
    int endIndex = (startIndex + perguntasPorPagina > perguntas.length)
        ? perguntas.length
        : startIndex + perguntasPorPagina;

    bool todasRespondidas = true;
    for (int i = startIndex; i < endIndex; i++) {
      if (!respostas.containsKey(perguntas[i]['id'])) {
        todasRespondidas = false;
        break;
      }
    }

    if (!todasRespondidas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Responda todas as perguntas da página para avançar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (currentPage >= totalPages - 1) {
      _enviarRespostas();
    } else {
      setState(() {
        currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(320.0, 384.0);
    const navH = 112.0;

    return Scaffold(
      backgroundColor: headerBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // ===== HEADER =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4EA),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(Icons.person, color: ink),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Acesso: $userCargo',
                              style: const TextStyle(fontSize: 10, color: ink),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfiguracoesPage(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: surface,
                            foregroundColor: ink,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          icon: const Icon(Icons.settings, size: 16),
                          label: const Text(
                            'Configurações',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== SURFACE BRANCA E CONTEÚDO =====
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: ink),
                          )
                        : errorMessage != null
                        ? Center(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : formConcluido
                        ? _buildTelaSucesso() // <--- TELA DE SUCESSO AQUI
                        : _buildConteudoFormulario(
                            navH,
                            bottomInset,
                          ), // <--- TELA DE PERGUNTAS
                  ),
                ),
              ],
            ),

            // ========= BOTTOM NAV =========
            // O Menu inferior some quando chega na tela de Sucesso!
            if (!formConcluido)
              Positioned(
                left: (size.width - navW) / 2,
                bottom: 8 + bottomInset,
                child: SharedBottomNav(currentIndex: 1, userCargo: userCargo),
              ),
          ],
        ),
      ),
    );
  }

  // PERGUNTAS DO QUESTIONÁRIO
  Widget _buildConteudoFormulario(double navH, double bottomInset) {
    int totalPages = (perguntas.length / perguntasPorPagina).ceil();
    int startIndex = currentPage * perguntasPorPagina;
    int endIndex = (startIndex + perguntasPorPagina > perguntas.length)
        ? perguntas.length
        : startIndex + perguntasPorPagina;
    List<dynamic> perguntasAtuais = perguntas.sublist(startIndex, endIndex);

    double progresso = (currentPage + 1) / totalPages;

    return ListView(
      padding: EdgeInsets.fromLTRB(24, 32, 24, navH + 16 + bottomInset),
      children: [
        const Text(
          'Formulário',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: inkDark,
          ),
        ),
        const SizedBox(height: 12),

        // BARRA DE PROGRESSO VERDE
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progresso,
            minHeight: 10,
            backgroundColor: const Color(0xFFCDE5E5),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF678D8A)),
          ),
        ),
        const SizedBox(height: 24),

        // CARD AMARELO COM AS PERGUNTAS
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Querido Aluno(a):',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: inkDark,
                ),
              ),
              const SizedBox(height: 20),

              ...perguntasAtuais.map((p) => _buildPerguntaItem(p)).toList(),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF678D8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Sair', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _avancarPagina,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF678D8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentPage >= totalPages - 1
                                      ? 'Concluir'
                                      : 'Próximo',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  currentPage >= totalPages - 1
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                  size: 18,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerguntaItem(dynamic pergunta) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pergunta['texto'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: inkDark,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(4, (index) {
              int valorOpcao = index + 1;
              bool isSelected = respostas[pergunta['id']] == valorOpcao;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 3 ? 6.0 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        respostas[pergunta['id']] = valorOpcao;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF678D8A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF678D8A)
                              : const Color(0xFFDED1BC),
                        ),
                      ),
                      child: Text(
                        opcoesTexto[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected ? Colors.white : inkDark,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Final do Questionário
  Widget _buildTelaSucesso() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // O Ícone de Círculo com Check Verde
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: successGreen, width: 8),
          ),
          child: const Icon(Icons.check, size: 80, color: successGreen),
        ),

        const SizedBox(height: 40),

        // O Texto
        const Text(
          'Formulário concluído com sucesso!!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: successGreen,
          ),
        ),

        const SizedBox(height: 48),

        // O Botão de Voltar ao Painel
        ElevatedButton(
          onPressed: () {
            // Joga o usuário direto pro Painel (Dashboard) limpando o histórico
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF304F55,
            ), // Cor escura padrão do projeto
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Voltar ao painel de controle',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
