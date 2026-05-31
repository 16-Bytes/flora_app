import 'package:flutter/material.dart';

import '../../core/theme/theme_ext.dart';
import 'configuracoes.dart';

/// Header compartilhado usado em todas as telas do portal.
class SharedHeader extends StatelessWidget {
  final String userName;
  final String userCargo;

  const SharedHeader({
    super.key,
    required this.userName,
    required this.userCargo,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(color: c.cardCream, borderRadius: BorderRadius.circular(999)),
            child: Icon(Icons.person, color: c.ink),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: TextStyle(fontSize: 14, height: 20 / 14, letterSpacing: 0.28, fontWeight: FontWeight.bold, color: c.ink)),
                const SizedBox(height: 2),
                Text('Acesso: $userCargo', style: TextStyle(fontSize: 10, height: 14 / 10, letterSpacing: 0.20, color: c.ink)),
              ],
            ),
          ),
          SizedBox(
            height: 37,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracoesPage())),
              style: ElevatedButton.styleFrom(backgroundColor: c.surface, foregroundColor: c.ink, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('Configurações', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
