import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Serviço centralizado para todas as chamadas HTTP da aplicação.
///
/// JWT armazenado com flutter_secure_storage (criptografado).
/// URLs lidas do .env via flutter_dotenv.
class ApiService {
  ApiService._();

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get floraiUrl => dotenv.env['FLORAI_URL'] ?? '';

  static const Duration _defaultTimeout = Duration(seconds: 15);
  static const _secureStorage = FlutterSecureStorage();

  // ─── Token Management ─────────────────────────────────────────────────

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  // ─── Headers ──────────────────────────────────────────────────────────

  static Future<Map<String, String>> _buildHeaders({
    bool withAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (withAuth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // ─── Requests ─────────────────────────────────────────────────────────

  static Future<http.Response> get(
    String path, {
    Duration timeout = _defaultTimeout,
  }) async {
    final headers = await _buildHeaders();
    return http
        .get(Uri.parse('$baseUrl$path'), headers: headers)
        .timeout(timeout);
  }

  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool withAuth = true,
    Duration timeout = _defaultTimeout,
  }) async {
    final headers = await _buildHeaders(withAuth: withAuth);
    return http
        .post(
          Uri.parse('$baseUrl$path'),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(timeout);
  }

  // ─── FlorAI ───────────────────────────────────────────────────────────

  static Future<http.Response> postFlorAI(
    String path, {
    Map<String, dynamic>? body,
    Duration timeout = _defaultTimeout,
  }) async {
    return http
        .post(
          Uri.parse('$floraiUrl$path'),
          headers: {'Content-Type': 'application/json'},
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(timeout);
  }

  static Future<http.StreamedResponse> uploadFlorAI(
    String path, {
    required String filePath,
    required String fieldName,
    Duration timeout = _defaultTimeout,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$floraiUrl$path'));
    request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
    return request.send().timeout(timeout);
  }

  // ─── Token Validation ─────────────────────────────────────────────────

  static Future<bool> isTokenValid() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return false;

      // Also migrate token from SharedPreferences if it exists there
      final prefs = await SharedPreferences.getInstance();
      final oldToken = prefs.getString('jwt_token');
      if (oldToken != null && oldToken.isNotEmpty) {
        await saveToken(oldToken);
        await prefs.remove('jwt_token');
      }

      final response = await get(
        '/api/dashboard',
        timeout: const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Erro ao validar token: $e');
      return false;
    }
  }
}
