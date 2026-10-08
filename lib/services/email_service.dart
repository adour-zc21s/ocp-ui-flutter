import 'dart:convert';
import 'api_http.dart' as http;
import '../models/email_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class EmailService {
  Future<void> addEmail({
    required String email,
    required String password,
    required String perfectName,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.emails),
      headers: await _authorizedHeaders(),
      body: jsonEncode({
        'email': email,
        'passwd': password,
        'perfectName': perfectName,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Gagal menambahkan email (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<void> updateEmail({
    required String id,
    required String email,
    required String password,
    required String perfectName,
  }) async {
    final response = await http.put(
      Uri.parse(ApiConfig.emailDetail(Uri.encodeComponent(id))),
      headers: await _authorizedHeaders(),
      body: jsonEncode({
        'email': email,
        'passwd': password,
        'perfectName': perfectName,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Gagal memperbarui email (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<Map<String, String>> _authorizedHeaders() async {
    final token = await AuthService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan. Silakan login kembali.');
    }
    final authorization = token.startsWith('Bearer ') ? token : 'Bearer $token';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': authorization,
    };
  }

  Future<List<Email>> fetchEmails() async {
    final response = await http.get(
      Uri.parse(ApiConfig.emails),
      headers: await _authorizedHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat email (${response.statusCode}): ${response.body}',
      );
    }
    final dynamic body = jsonDecode(response.body);
    final List<dynamic> content = body is Map ? body['content'] : body;
    return content.map((item) => Email.fromJson(item)).toList();
  }

  // Method pencarian email
  Future<List<Email>> searchEmails(String query) async {
    final encodedQuery = Uri.encodeQueryComponent(query.trim());
    final url = Uri.parse('${ApiConfig.emailSearch}?email=$encodedQuery');
    final response = await http.get(url, headers: await _authorizedHeaders());
    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mencari email (${response.statusCode}): ${response.body}',
      );
    }
    final dynamic body = jsonDecode(response.body);
    final List<dynamic> content = body is Map ? (body['content'] ?? []) : body;
    return content.map((item) => Email.fromJson(item)).toList();
  }
}
