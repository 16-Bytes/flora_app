import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importante para ler a memória
import 'shared_bottom_nav.dart';
import 'configuracoes.dart';

// ------------------------------------
// MODELO DO ALUNO E MOCK DE DADOS
class Aluno {
  final String nome;
  final int matricula;
  final String status;
  final Color statusColor;

  Aluno(this.nome, this.matricula, this.status, this.statusColor);
}

final mockAlunos = [
  Aluno('Lucas Almeida', 996, 'Pendente', const Color(0xFFE7E3DF)),
  Aluno('Mariana Costa', 999, 'Entregue', const Color(0xFFE9EAD1)),
  Aluno('Rafael Souza', 987, 'Verificado', const Color(0xFFD8EFEB)),
  Aluno('Pedro Henrique Lima', 985, 'Verificado', const Color(0xFFD8EFEB)),
  Aluno('Bruno Carvalho', 993, 'Verificado', const Color(0xFFD8EFEB)),
];
// ------------------------------------

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  // Variáveis para guardar os dados do usuário....
  String userName = 'Calma...'; //MEME MUDA ISSO DPS PFV
  String userCargo = '...';

  @override
  void initState() {
    super.initState();
    _carregarDadosDoUsuario();
  }

  // Função assíncrona para buscar os dados no cofre do celular
  Future<void> _carregarDadosDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userName =
            prefs.getString('usuario_nome') ??
            'Usuário Desconhecido'; //Eu estou falando com mauro ou oruam?
        String cargoCru = prefs.getString('usuario_cargo') ?? 'aluno';
        userCargo = cargoCru.replaceFirst(
          cargoCru[0],
          (cargoCru[0]).toUpperCase(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navW = (w - 24).clamp(320.0, 384.0);

    return Scaffold(
      backgroundColor: const Color(0xFF97C2C1),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // BODY PRINCIPAL
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
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF304F55),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOME DINÂMICO
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF304F55),
                              ),
                            ),
                            const SizedBox(height: 2),
                            // CARGO DINÂMICO
                            Text(
                              'Acesso: $userCargo',
                              style: const TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.20,
                                color: Color(0xFF304F55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConfiguracoesPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEF9F2),
                            foregroundColor: const Color(0xFF304F55),
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

                // Contiudo
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF9F2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        23,
                        26,
                        23,
                        140 + bottomInset,
                      ),
                      children: [
                        const Text(
                          'Alunos',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF233B3E),
                          ),
                        ),
                        const SizedBox(height: 18),

                        const _SearchPill(),

                        const SizedBox(height: 16),
                        const _FiltroRow(),

                        const SizedBox(height: 10),
                        // Listas
                        ...mockAlunos.map((aluno) => _AlunoCard(aluno: aluno)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // NaVBAR
            Positioned(
              left: (w - navW) / 2,
              bottom: 8 + bottomInset,
              child: SharedBottomNav(
                currentIndex: 1, // Índice 1 = Alunos
                userCargo:
                    userCargo, // Passa a variável lida para o menu saber qual desenhar
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// COMPONENTES Tela

class _SearchPill extends StatelessWidget {
  const _SearchPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9F2),
        border: Border.all(color: const Color(0xFFDED1BC)),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Row(
        children: [
          Icon(Icons.search, size: 18, color: Color(0xFF727879)),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar alunos, relatórios...',
                hintStyle: TextStyle(color: Color(0xFFDED1BC)),
              ),
              style: TextStyle(fontSize: 16, color: Color(0xFF304F55)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroRow extends StatelessWidget {
  const _FiltroRow();

  final List<String> filtros = const ['Nome', 'Turma', 'Status'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var f in filtros)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE7E3DF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              f,
              style: const TextStyle(
                color: Color(0xFF304F55),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

class _AlunoCard extends StatelessWidget {
  final Aluno aluno;
  const _AlunoCard({required this.aluno});

  Color _statusColor() {
    switch (aluno.status) {
      case 'Pendente':
        return const Color(0xFFCFCBC7);
      case 'Entregue':
        return const Color(0xFFE2E497);
      case 'Verificado':
        return const Color(0xFF92C2A9);
      default:
        return Colors.grey;
    }
  }

  Color _statusTextColor() {
    switch (aluno.status) {
      case 'Pendente':
        return const Color(0xFFBF8E7B);
      case 'Entregue':
        return const Color(0xFF787B30);
      case 'Verificado':
        return const Color(0xFF086652);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: aluno.status == "Pendente"
            ? const Color(0xFFE7E3DF)
            : aluno.status == "Entregue"
            ? const Color(0xFFE9EAD1)
            : const Color(0xFFD8EFEB),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome e Tag de Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                aluno.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF233B3E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  aluno.status,
                  style: TextStyle(
                    fontSize: 13,
                    color: _statusTextColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            aluno.matricula.toString(),
            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 10),

          // Botões de Ação
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.insert_drive_file_rounded, size: 18),
                  label: const Text('Visualizar relatório'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF47967D),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.15,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.edit,
                  color: Color(0xFF304F55),
                  size: 18,
                ),
                label: const Text(
                  'Editar',
                  style: TextStyle(
                    color: Color(0xFF304F55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAEEEC),
                  foregroundColor: const Color(0xFF304F55),
                  minimumSize: const Size(0, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
