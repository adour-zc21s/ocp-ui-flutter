import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/email_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class EmailService {

  Future<List<Email>> fetchEmails() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.emails);
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => Email.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat email: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
