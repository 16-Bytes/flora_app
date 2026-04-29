import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    try {
      final uri = Uri.parse('http://168.75.73.9/login');

      // Isso imita um <form method="POST"> do HTML:
      // ...
      final res = await http
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: {'email': email, 'senha': senha},
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      // SUCESSO: 200..299 ou 302 (redirect típico de login)
      if ((res.statusCode == 302)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        setState(() {
          errorMessage = 'Email ou senha inválidos. (HTTP ${res.statusCode})';
        });
      }
    } on TimeoutException {
      setState(() => errorMessage = 'Tempo esgotado. Tente novamente.');
    } catch (e) {
      setState(() => errorMessage = 'Erro de conexão: $e');
    } finally {
      if (mounted) {
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
            height: 860,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
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
                  top: 144,
                  left: (w - 156.48) / 2,
                  child: Image.asset(
                    'assets/images/soon.png',
                    width: 156.48,
                    height: 176,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  top: 404,
                  left: (w - 132) / 2,
                  child: const SizedBox(
                    width: 132,
                    height: 58,
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
                    top: 470,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCCCC),
                        borderRadius: BorderRadius.circular(8),
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
                  top: 494.41,
                  child: _PillField(
                    icon: const _UserIcon(color: ink),
                    hintText: 'Digite seu email',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                  ),
                ),

                Positioned(
                  left: side,
                  right: side,
                  top: 570,
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
                  top: 645.59,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                  top: 764,
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
            width: 33.33,
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

// Ícones simples (sem dependências externas)
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
      size: const Size(13.33, 17.5),
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
