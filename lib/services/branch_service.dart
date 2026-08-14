import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/branch_model.dart';
import 'api_config.dart';
import 'auth_service.dart';
import '../models/branch_status_model.dart';

class BranchService {
  Future<List<Branch>> fetchBranches() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.brances);
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => Branch.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat branches: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method pencarian branch (SUDAH DISESUAIKAN DENGAN BACKEND)
  Future<List<Branch>> searchBranches(String query) async {
    try {
      final token = await AuthService.getToken();

      // 👈 GANTI 'query' MENJADI 'letter' DI SINI
      final url = Uri.parse('${ApiConfig.cariBranches}?letter=${query.trim()}');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? (body['content'] ?? []) : body;

        return content.map((item) => Branch.fromJson(item)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi login telah berakhir. Silakan login kembali.');
      } else {
        throw Exception('Gagal mencari branch (${response.statusCode})');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BranchStatus> checkBranchStatus(int branchId) async {
    try {
      final token = await AuthService.getToken();

      // 👈 Gunakan method pembantu di sini
      final url = Uri.parse(ApiConfig.branchDetailStatus(branchId));

      final headers = <String, String>{
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return BranchStatus.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Gagal memuat status (${response.statusCode})');
      }
    } catch (e) {
      rethrow;
    }
  }
}
