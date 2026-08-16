import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monitoring_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class MonitoringService {
  Future<List<Monitoring>> fetchMonitoring() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.monitoring);
      final headers = <String, String>{'Content-Type': 'application/json'};

      // print('=== DEBUG API MONITORING ===');
      // print('URL Endpoint: $url');
      // print('Token dari Storage: "$token"'); // Cek apakah null atau empty

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // print(
      //   'Request Headers: $headers',
      // ); // Cek apakah header Authorization terpasang

      final response = await http.get(url, headers: headers);

      // // 🔍 2. PRINT DEBUGGING SETELAH RESPON
      // print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      // print('===========================');

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => Monitoring.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat monitoring: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error pada fetchMonitoring: $e'); // 🔍 3. PRINT EKSPEPSI / ERROR
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
