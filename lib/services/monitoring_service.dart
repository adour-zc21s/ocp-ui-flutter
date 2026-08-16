import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monitoring_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class MonitoringService {
  // Method pembantu untuk mengambil dan membersihkan token dari karakter tersembunyi
  Future<String?> _getCleanToken() async {
    final rawToken = await AuthService.getToken();
    if (rawToken == null || rawToken.isEmpty) return null;

    // Membersihkan whitespace, \n, dan \r yang merusak header HTTP
    return rawToken.replaceAll('\n', '').replaceAll('\r', '').trim();
  }

  Future<List<Monitoring>> fetchMonitoring() async {
    try {
      final token = await _getCleanToken();
      final url = Uri.parse(ApiConfig.monitoring);

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // print('=== DEBUG API MONITORING ===');
      // print('URL Endpoint: $url');
      // print('Token Bersih: "$token"');
      // print('Request Headers: $headers');

      final response = await http.get(url, headers: headers);

      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // print('===========================');

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? (body['content'] ?? []) : body;
        return content.map((item) => Monitoring.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception(
          '401 Unauthorized: Sesi berakhir atau token tidak valid.',
        );
      } else {
        throw Exception('Gagal memuat monitoring: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error pada fetchMonitoring: $e');
      rethrow;
    }
  }

  Future<Monitoring> checkMonitoringStatus(int id) async {
    try {
      final token = await AuthService.getToken();

      // 👈 Gunakan method pembantu di sini
      final url = Uri.parse(ApiConfig.monitoringDetailStatus(id));

      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return Monitoring.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Gagal memuat status (${response.statusCode})');
      }
    } catch (e) {
      rethrow;
    }
  }
}
