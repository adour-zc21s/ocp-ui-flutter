import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ticket_model.dart';
import 'api_config.dart';
import 'auth_service.dart';
import '../models/ticket_comment_model.dart';

class TicketService {
  Future<List<Ticket>> fetchOpenTickets() async {
    try {
      final token = await AuthService.getToken();

      // Menggunakan URL persis seperti uji coba Postman
      final url = Uri.parse(
        '${ApiConfig.tickets}?page=0&size=10&sort=createdAt,desc',
      );

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // print('Token yang dikirim: "$token"');
      // print('Headers: $headers');

      final response = await http.get(url, headers: headers);

      // print('Status Code Ticket: ${response.statusCode}');
      // print('Response Body Ticket: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => Ticket.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat tiket: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Ini methode untuk mengambil detail tiket berdasarkan ID
  Future<List<TicketComment>> fetchTicketComments(String ticketId) async {
    try {
      final token = await AuthService.getToken();

      final url = Uri.parse('${ApiConfig.tickets}/$ticketId/comments');

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        List<dynamic> content = body is Map ? body['content'] : body;
        return content.map((item) => TicketComment.fromJson(item)).toList();
      } else {
        throw Exception(
            'Gagal memuat komentar tiket: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Ini methode untuk menambahkan komentar ke tiket
  Future<void> addComment(String ticketId, String comment) async {
    try {
      final token = await AuthService.getToken();

      final url = Uri.parse('${ApiConfig.tickets}/$ticketId/comments');

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = jsonEncode({'comment': comment});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 201) {
        throw Exception(
            'Gagal menambahkan komentar: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTicket({
    required String judul,
    required String emailNotification,
    required String branch,
    required String departemen,
  }) async {
    try {
      final token = await AuthService.getToken();

      final url = Uri.parse(ApiConfig.tickets);

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = jsonEncode({
        'judul': judul,
        'emailNotification': emailNotification,
        'branch': branch,
        'departemen': departemen,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal membuat tiket: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, String>>> fetchTicketAccounts() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.ticketAccounts);

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Ambil name dan email dari response API
        final List<Map<String, String>> accounts = data
            .map<Map<String, String>>((account) {
              if (account is Map<String, dynamic>) {
                return {
                  'name': account['name']?.toString() ?? 'Tanpa Nama',
                  'email': account['email']?.toString() ?? '',
                };
              }
              return {'name': account.toString(), 'email': account.toString()};
            })
            .where((acc) => acc['email']!.isNotEmpty)
            .toList();

        // Urutkan berdasarkan name (A-Z)
        accounts.sort(
          (a, b) =>
              a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()),
        );

        return accounts;
      } else {
        throw Exception('Gagal memuat akun: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
