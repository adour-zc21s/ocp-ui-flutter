import 'dart:convert';
import 'api_http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

class PocketService {
  Future<List<Map<String, dynamic>>> fetchPockets() async {
    final token = await AuthService.getToken();
    final headers = _authorizedHeaders(token);
    final response = await http.get(
      Uri.parse(ApiConfig.pockets).replace(
        queryParameters: {
          '_refresh': DateTime.now().microsecondsSinceEpoch.toString(),
        },
      ),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat pocket (${response.statusCode}): ${response.body}',
      );
    }

    dynamic records = jsonDecode(response.body);
    const collectionKeys = [
      'content',
      'data',
      'pockets',
      'results',
      'records',
      'transactions',
      'entries',
    ];
    while (records is Map) {
      dynamic nestedRecords;
      for (final key in collectionKeys) {
        if (records[key] != null) {
          nestedRecords = records[key];
          break;
        }
      }
      if (nestedRecords == null) {
        records = [records];
        break;
      }
      records = nestedRecords;
    }
    if (records is! List) {
      throw const FormatException('Format data pocket tidak valid.');
    }

    return records
        .whereType<Map>()
        .map((record) => record.cast<String, dynamic>())
        .toList();
  }

  Future<void> addPocketEntry({
    required String title,
    required double amount,
    required String type,
    int pocketId = 1,
  }) async {
    final token = await AuthService.getToken();
    final response = await http.post(
      Uri.parse(ApiConfig.pocketItems(pocketId)),
      headers: _authorizedHeaders(token),
      body: jsonEncode({'title': title, 'amount': amount, 'type': type}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Gagal menambahkan item ke pocket (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<dynamic> fetchMonthlyReport(int pocketId) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse(ApiConfig.pocketMonthlyReport(pocketId)),
      headers: _authorizedHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal memuat report pocket (${response.statusCode}): ${response.body}',
      );
    }

    return jsonDecode(response.body);
  }

  Map<String, String> _authorizedHeaders(String? token) {
    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan. Silakan login kembali.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
