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
        '${ApiConfig.tickets}?page=0&size=50&sort=createdAt,desc',
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
  Future<void> addComment(
    String ticketId,
    String comment,
    String author, // 👈 Tambahkan parameter author/user
  ) async {
    try {
      final token = await AuthService.getToken();

      final url = Uri.parse('${ApiConfig.tickets}/$ticketId/comments');

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final body = jsonEncode({
        'comment': comment,
        'commentedBy': author,
        });

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
    required String jenisDukungan,
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
        'jenisDukungan': jenisDukungan,
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

  // Fetch List Department
  Future<List<Map<String, String>>> fetchTicketDepartments() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.ticketDepartments);

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<Map<String, String>> list = data
            .map<Map<String, String>>((item) {
              if (item is Map<String, dynamic>) {
                return {
                  'id':
                      item['id']?.toString() ?? item['name']?.toString() ?? '',
                  'name':
                      item['name']?.toString() ??
                      item['departmentName']?.toString() ??
                      '',
                };
              }
              return {'id': item.toString(), 'name': item.toString()};
            })
            .where((element) => element['name']!.isNotEmpty)
            .toList();

        list.sort(
          (a, b) =>
              a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()),
        );
        return list;
      } else {
        throw Exception('Gagal memuat department: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fetch List Branch
  Future<List<Map<String, String>>> fetchTicketBranches() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.ticketBranches);

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<Map<String, String>> list = data
            .map<Map<String, String>>((item) {
              if (item is Map<String, dynamic>) {
                return {
                  'id':
                      item['id']?.toString() ?? item['name']?.toString() ?? '',
                  'name':
                      item['name']?.toString() ??
                      item['branchName']?.toString() ??
                      '',
                };
              }
              return {'id': item.toString(), 'name': item.toString()};
            })
            .where((element) => element['name']!.isNotEmpty)
            .toList();

        list.sort(
          (a, b) =>
              a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()),
        );
        return list;
      } else {
        throw Exception('Gagal memuat branch: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fetch support ticket
  Future<List<Map<String, String>>> fetchTicketSupportType() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.ticketSupport);

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<Map<String, String>> list = data
            .map<Map<String, String>>((item) {
              if (item is Map<String, dynamic>) {
                return {
                  'id':
                      item['id']?.toString() ?? item['name']?.toString() ?? '',
                  'name':
                      item['name']?.toString() ??
                      item['branchName']?.toString() ??
                      '',
                };
              }
              return {'id': item.toString(), 'name': item.toString()};
            })
            .where((element) => element['name']!.isNotEmpty)
            .toList();

        list.sort(
          (a, b) =>
              a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()),
        );
        return list;
      } else {
        throw Exception('Gagal memuat support type: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> closeTicket(String id) async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.ticketClose(id));

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // Menggunakan HTTP POST atau PUT (sesuaikan dengan metode di backend Anda)
      final response = await http.put(url, headers: headers);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Gagal menutup tiket: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
