import 'dart:async';
import 'dart:convert'; // Necessário para jsonEncode e jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Para salvar a sessão

import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _senha = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final senha = _senha.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() => errorMessage = 'Preencha email e senha.');
      return;
    }

    // Recolhe o teclado antes de começar
    FocusScope.of(context).unfocus();

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    bool loginComSucesso = false;

    try {
      // 1. Atualizamos a URL para o novo padrão da API
      final uri = Uri.parse('http://168.75.73.9/api/login');

      // 2. Agora enviamos como JSON (padrão de APIs modernas)
      final res = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'senha': senha}),
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      // 3. Lê a resposta da API (que agora é um JSON)
      final respostaAPI = jsonDecode(res.body);

      // SUCESSO: O Node.js retorna HTTP 200 e sucesso: true
      if (res.statusCode == 200 && respostaAPI['sucesso'] == true) {
        loginComSucesso = true;

        // 4. SALVA O TOKEN NO CELULAR (A MÁGICA DA SESSÃO!)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', respostaAPI['token']);
        await prefs.setString('usuario_nome', respostaAPI['usuario']['nome']);
        await prefs.setString('usuario_cargo', respostaAPI['usuario']['cargo']);

        // 5. Navega para o Dashboard com a animação suave
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const DashboardPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
          ),
        );
      } else {
        // FALHA NO LOGIN (Senha errada, etc)
        setState(() {
          errorMessage = respostaAPI['erro'] ?? 'Erro ao fazer login.';
        });
      }
    } on TimeoutException {
      setState(() => errorMessage = 'Tempo esgotado. Verifique sua internet.');
    } catch (e) {
      setState(() => errorMessage = 'Erro de conexão com o servidor.');
    } finally {
      if (mounted && !loginComSucesso) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFB4D4D3);
    const ink = Color(0xFF304F55);
    const topCard = Color(0xFFFFF4EA);
    const btnBg = Color(0xFF233B3E);

    final w = MediaQuery.sizeOf(context).width;
    final side = w <= 360 ? 20.0 : 40.0;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: 800,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: -25,
                  child: Container(
                    height: 365,
                    decoration: const BoxDecoration(
                      color: topCard,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 110,
                  left: (w - 156.48) / 2,
                  child: Image.asset(
                    'assets/images/soon.png',
                    width: 156.48,
                    height: 176,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: 355,
                  left: (w - 132) / 2,
                  child: const SizedBox(
                    width: 132,
                    height: 63,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          height: 58 / 48,
                          fontWeight: FontWeight.w400,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                ),

                if (errorMessage != null)
                  Positioned(
                    left: side,
                    right: side,
                    top: 420,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCCCC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCC0000),
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  left: side,
                  right: side,
                  top: 465,
                  child: _PillField(
                    icon: const _UserIcon(color: ink),
                    hintText: 'Digite seu e-mail',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),

                Positioned(
                  left: side,
                  right: side,
                  top: 535,
                  child: _PillField(
                    icon: const _LockIcon(color: ink),
                    hintText: 'Digite sua senha',
                    controller: _senha,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),

                Positioned(
                  left: side,
                  right: side,
                  top: 620,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBg,
                        foregroundColor: bg,
                        shape: const StadiumBorder(),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: bg,
                              ),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                letterSpacing: 0.28,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                ),

                Positioned(
                  top: 725,
                  left: (w - 278) / 2,
                  child: const SizedBox(
                    width: 278,
                    height: 31,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '“Onde cada mente floresce”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          height: 30 / 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          color: ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({
    required this.icon,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
  });

  final Widget icon;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFB4D4D3);
    const ink = Color(0xFF304F55);

    return Container(
      height: 59.59,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: ink, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SizedBox(
            width: 15,
            height: 24,
            child: Align(alignment: Alignment.centerLeft, child: icon),
          ),
          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: ink),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: const TextStyle(
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w400,
                color: ink,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: ink),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}

class _UserIcon extends StatelessWidget {
  const _UserIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(13.33, 13.33),
      painter: _UserPainter(color),
    );
  }
}

class _UserPainter extends CustomPainter {
  _UserPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.35),
      size.width * 0.24,
      p,
    );

    final path = Path()
      ..moveTo(size.width * 0.05, size.height * 0.95)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.62,
        size.width * 0.95,
        size.height * 0.95,
      );

    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LockIcon extends StatelessWidget {
  const _LockIcon({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(15, 17.5),
      painter: _LockPainter(color),
    );
  }
}

class _LockPainter extends CustomPainter {
  _LockPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, size.height * 0.45, size.width - 2, size.height * 0.5),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, p);

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.45)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.15,
        size.width * 0.75,
        size.height * 0.15,
        size.width * 0.75,
        size.height * 0.45,
      );
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
