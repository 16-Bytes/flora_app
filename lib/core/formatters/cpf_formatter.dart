import 'package:flutter/services.dart';

/// Formata CPF automaticamente: XXX.XXX.XXX-XX
/// Aceita apenas dígitos e aplica pontuação em tempo real.
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não é dígito
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limita a 11 dígitos
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;

    // Aplica a máscara
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 3 || i == 6) buffer.write('.');
      if (i == 9) buffer.write('-');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
