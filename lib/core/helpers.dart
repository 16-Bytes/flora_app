import 'package:shared_preferences/shared_preferences.dart';

import 'services/api_service.dart';

/// Capitaliza a primeira letra de uma string.
String capitalizarPrimeira(String texto) {
  if (texto.isEmpty) return texto;
  return texto[0].toUpperCase() + texto.substring(1).toLowerCase();
}

/// Dados básicos do usuário.
class DadosUsuario {
  final String nome;
  final String cargo;
  final String token;

  const DadosUsuario({
    required this.nome,
    required this.cargo,
    required this.token,
  });
}

/// Cache em memória para evitar leitura do disco a cada navegação.
DadosUsuario? _dadosCache;

/// Carrega dados do usuário. Token vem do secure storage, nome/cargo do SharedPreferences.
///
/// Após a primeira leitura, retorna da memória instantaneamente.
/// Chame [invalidarDadosCache] ao fazer login/logout para forçar releitura.
Future<DadosUsuario> carregarDadosUsuario() async {
  if (_dadosCache != null) return _dadosCache!;

  final prefs = await SharedPreferences.getInstance();
  final token = await ApiService.getToken() ?? '';

  final nome = prefs.getString('usuario_nome') ?? 'Usuário';
  final cargoCru = prefs.getString('usuario_cargo') ?? 'aluno';

  _dadosCache = DadosUsuario(
    nome: nome,
    cargo: capitalizarPrimeira(cargoCru),
    token: token,
  );

  return _dadosCache!;
}

/// Invalida o cache de dados do usuário.
/// Deve ser chamado no login e no logout.
void invalidarDadosCache() {
  _dadosCache = null;
}
