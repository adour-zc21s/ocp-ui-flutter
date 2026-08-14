import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import 'api_config.dart';

class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              LoginRequest(email: email, password: password).toJson(),
            ),
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code Login: ${response.statusCode}');
      print('Response Body Login: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);

        // 👈 COCOKKAN DENGAN KEY BACKEND: access_token
        final String? token = body['access_token'];

        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          print('✅ SUCCESS: Token berhasil tersimpan -> $token');
        } else {
          print('❌ ERROR: Key access_token tidak ditemukan di response!');
        }

        return LoginResponse.fromJson(body);
      } else {
        throw Exception('Login gagal (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('Detail Error Login: $e');
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    print('🔑 Membaca token dari SharedPreferences: $token');
    return token;
  }
}
