//GNT AQUI EU DESISTI MSM VIU DSCP MAS EU NÃO AGUENTO MAIIIISS CHEGA DE DESIGN PRR
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Importe a sua tela de login

class ConfiguracoesPage extends StatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  static const headerBg = Color(0xFF97C2C1);
  static const surface = Color(0xFFFEF9F2);
  static const ink = Color(0xFF304F55);
  static const cardBg = Color(
    0xFFCDE5E5,
  ); // Cor do fundo do card de configurações

  String userName = 'Carregando...';
  String userCargo = '...';
  String userEmail = 'carregando...';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('usuario_nome') ?? 'Usuário Desconhecido';
      userCargo = (prefs.getString('usuario_cargo') ?? 'aluno').toUpperCase();

      // Como a API ainda não manda o email, estou criando um provisório baseado no nome
      // Futuramente, é só salvar o email no login e puxar aqui!
      userEmail = '${userCargo.split(' ').first.toLowerCase()}@flora.com';
    });
  }

  // A MÁGICA DO LOGOUT
  Future<void> _fazerLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Apaga o Token e os dados salvos

    if (mounted) {
      // pushAndRemoveUntil joga para o Login e DESTRÓI todas as telas anteriores.
      // Assim o usuário não consegue apertar "Voltar" no celular e voltar pro Dashboard.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: headerBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ===== HEADER (Igual ao Dashboard) =====
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
                ],
              ),
            ),

            // ===== SUPERFÍCIE BRANCA =====
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
                  padding: const EdgeInsets.all(24),
                  children: [
                    const Text(
                      'Configurações',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ===== CARD VERDE DE CONFIGURAÇÕES =====
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botão Voltar
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A5C60),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_back, size: 16),
                            label: const Text('Voltar'),
                          ),
                          const SizedBox(height: 20),

                          // TEMA (MOCK VISUAL)
                          const Center(
                            child: Text('Tema:', style: TextStyle(color: ink)),
                          ),
                          const SizedBox(height: 8),
                          _buildMockToggle(
                            'Modo claro:',
                            'Modo escuro:',
                            Icons.nightlight_round,
                          ),
                          const SizedBox(height: 20),

                          // NOTIFICAÇÕES (MOCK VISUAL)
                          const Center(
                            child: Text(
                              'Notificações:',
                              style: TextStyle(color: ink),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMockToggle(
                            'Ativada:',
                            'Desativada:',
                            Icons.notifications_off,
                          ),
                          const SizedBox(height: 20),

                          const Divider(color: ink, thickness: 0.5),
                          const SizedBox(height: 10),

                          // PERFIL CONECTADO E BOTÃO DE SAIR
                          const Center(
                            child: Text(
                              'Perfil conectado:',
                              style: TextStyle(
                                color: ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Usuário: $userName',
                            style: const TextStyle(color: ink, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Email: $userEmail',
                            style: const TextStyle(color: ink, fontSize: 13),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              // Botão Sair (Substituiu o "Trocar")
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _fazerLogout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF97C2C1,
                                    ), // Verde mais claro
                                    foregroundColor: ink,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.logout, size: 16),
                                  label: const Text('Sair'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Botão Editar
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Edição em breve!'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                      0xFF678D8A,
                                    ), // Verde mais escuro
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Editar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget só para simular o visual dos botões de "Tema" e "Notificações" da sua imagem
  Widget _buildMockToggle(
    String labelLeft,
    String labelRight,
    IconData rightIcon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(labelLeft, style: const TextStyle(fontSize: 10, color: ink)),
            Text(labelRight, style: const TextStyle(fontSize: 10, color: ink)),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFF4A5C60), // Fundo escuro do mock
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 37,
                height: 37,
                decoration: const BoxDecoration(
                  color: Color(0xFFCDE5E5),
                  shape: BoxShape.circle,
                ),
                child: Icon(rightIcon, color: ink, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
