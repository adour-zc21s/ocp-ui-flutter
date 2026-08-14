import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/device_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class DeviceService {

  Future<List<Device>> fetchDevices() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.devices);
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => Device.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat device: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
