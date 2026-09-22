import 'dart:convert';
import 'dart:io' as io;
import '../models/model_user.dart';
import 'auth_storage.dart';

class ApiService {
  // Ajuste para o IP local (ex: http://10.0.2.2:5000 no emulador Android ou http://localhost:5000 na Web)
  static const String baseUrl = 'http://localhost:5000/api';

  // Header padrão para requisições não autenticadas
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<_ApiResponse> _request(
    String method,
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final client = io.HttpClient();
    try {
      final request = await client.openUrl(method, Uri.parse(url));
      (headers ?? {}).forEach(request.headers.set);
      if (body != null) {
        request.write(body is String ? body : jsonEncode(body));
      }
      final response = await request.close();
      return _ApiResponse(
        response.statusCode,
        await response.transform(utf8.decoder).join(),
      );
    } finally {
      client.close(force: true);
    }
  }

  // Login: Autentica e salva o JWT
  static Future<UserRole> login({
    required String email,
    required String password,
  }) async {
    final response = await _request(
      'POST',
      '$baseUrl/auth/login',
      headers: _headers,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'] as String;
      final roleStr = data['user']['role'] as String;
      final userId = data['user']['id'].toString();

      final role = roleStr == 'ong' ? UserRole.ong : UserRole.voluntario;

      await AuthStorage.saveAuthData(
        token: token,
        role: role,
        userId: userId,
      );

      return role;
    } else {
      throw Exception(data['message'] ?? 'Falha ao autenticar.');
    }
  }

  // Cadastro: Registra Voluntário ou ONG
  static Future<void> register({
    required String name,
    required String email,
    required String password,
    required String document, // CPF ou CNPJ
    required UserRole role,
  }) async {
    final response = await _request(
      'POST',
      '$baseUrl/auth/register',
      headers: _headers,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'document': document.trim(),
        'role': role == UserRole.ong ? 'ong' : 'voluntario',
      },
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Erro ao criar conta.');
    }
  }

  // Recuperação de Senha
  static Future<void> forgotPassword(String email) async {
    final response = await _request(
      'POST',
      '$baseUrl/auth/forgot-password',
      headers: _headers,
      body: {'email': email.trim()},
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Falha ao solicitar recuperação.');
    }
  }

  // Exemplo de requisição autenticada utilizando o Bearer Token
  static Future<List<dynamic>> getVagas() async {
    final token = await AuthStorage.getToken();
    if (token == null) throw Exception('Não autenticado.');

    final response = await _request(
      'GET',
      '$baseUrl/vagas',
      headers: {
        ..._headers,
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await AuthStorage.clearAuth();
      throw Exception('Sessão expirada. Faça login novamente.');
    } else {
      throw Exception('Falha ao carregar oportunidades.');
    }
  }
}

class _ApiResponse {
  final int statusCode;
  final String body;

  const _ApiResponse(this.statusCode, this.body);
}