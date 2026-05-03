import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_bottom_nav.dart';
import 'configuracoes.dart';
import 'questionario.dart'; // <--- Nova tela 2

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  static const headerBg = Color(0xFF97C2C1);
  static const surface = Color(0xFFFEF9F2);
  static const ink = Color(0xFF304F55);
  static const inkDark = Color(0xFF233B3E);
  static const cardBg = Color(0xFFE8E0B0);

  String userName = 'Carregando...';
  String userCargo = '...';

  bool isLoading = true;
  int? avaliacaoPendenteId;
  int? questionarioPendenteId;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ?? '';

    setState(() {
      userName = prefs.getString('usuario_nome') ?? 'Usuário';
      userCargo = (prefs.getString('usuario_cargo') ?? 'aluno').toUpperCase();
    });

    try {
      // busca para a API se tem avaliação pendente para esse aluno
      final res = await http
          .get(
            Uri.parse('http://168.75.73.9/api/dashboard'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['avaliacoes_pendentes'] != null &&
            data['avaliacoes_pendentes'].isNotEmpty) {
          // Pega a primeira avaliação que estiver pendente
          final primeiraPendente = data['avaliacoes_pendentes'][0];
          setState(() {
            avaliacaoPendenteId = primeiraPendente['id'];
            questionarioPendenteId = primeiraPendente['questionario_id'];
          });
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar pendências: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (size.width - 24).clamp(320.0, 384.0);
    const navH = 112.0;

    // Lógica para o botão, eu não entendi mas se funciona deixa filho gpt não erra
    final temPendente =
        avaliacaoPendenteId != null && questionarioPendenteId != null;

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

                // ===== SURFACE BRANCA =====
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
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        32,
                        24,
                        navH + 16 + bottomInset,
                      ),
                      children: [
                        const Text(
                          'Formulário',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: inkDark,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ===== CARD AMARELO DE INSTRUÇÕES =====
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pronto para Florescer?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: inkDark,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Olá! Queremos conhecer melhor o seu perfil para tornar a escola um lugar mais acolhedor.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: inkDark,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Dicas rápidas:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: inkDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildBulletPoint(
                                'Sinceridade: Não há respostas certas ou erradas; sua visão real é o que importa.',
                              ),
                              const SizedBox(height: 4),
                              _buildBulletPoint(
                                'Escala: Use de 1 a 5 para responder.',
                              ),
                              const SizedBox(height: 16),

                              // MENSAGEM DINÂMICA
                              if (isLoading)
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: inkDark,
                                  ),
                                )
                              else if (!temPendente)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Você não tem formulários pendentes no momento! 🎉',
                                    style: TextStyle(
                                      color: inkDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              else ...[
                                const Text(
                                  'Podemos iniciar?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: inkDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // BOTÃO INICIAR
                                Center(
                                  child: SizedBox(
                                    width: 180,
                                    height: 45,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Abre a tela das perguntas passando os IDs que da API
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => QuestionarioPage(
                                              avaliacaoId: avaliacaoPendenteId!,
                                              questionarioId:
                                                  questionarioPendenteId!,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF678D8A,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.play_arrow_outlined,
                                        size: 20,
                                      ),
                                      label: const Text(
                                        'Iniciar',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

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
  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0, right: 8.0, left: 4.0),
          child: Icon(Icons.circle, size: 6, color: inkDark),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: inkDark, height: 1.5),
          ),
        ),
      ],
    );
  }
}

//AI chega não aguento mais LUCAS, vc que se fd pra terminar isso bjs <3 
