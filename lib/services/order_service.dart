import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../models/item_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class OrderService {
  static double? _parseRevenueNumber(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(value.replaceAll(',', ''));
      if (parsed != null) return parsed;
    }

    return null;
  }

  static double parseRevenue(dynamic body) {
    if (body is! Map) return 0.0;

    final candidates = [
      body['totalAmount'],
      body['data'] is Map ? body['data']['totalAmount'] : null,
      body['content'] is Map ? body['content']['totalAmount'] : null,
      body['result'] is Map ? body['result']['totalAmount'] : null,
    ];

    for (final candidate in candidates) {
      final parsed = _parseRevenueNumber(candidate);
      if (parsed != null) {
        return parsed;
      }
    }

    return 0.0;
  }

  Future<List<Item>> fetchOrderItems() async {
    final token = await AuthService.getToken();
    final url = Uri.parse(ApiConfig.orderItem);
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat item order: ${response.statusCode}');
    }

    final dynamic body = jsonDecode(response.body);
    final List<dynamic> content = body is Map
        ? (body['content'] ??
              body['data'] ??
              body['items'] ??
              body['orderItems'] ??
              [])
        : body;

    return content.map((value) {
      final item = value is Map && value['item'] is Map
          ? value['item'] as Map
          : value as Map;
      return Item.fromJson(item.cast<String, dynamic>());
    }).toList();
  }

  Future<List<Order>> fetchOrders() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.orders);

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        final List<dynamic> content = body is Map
            ? (body['content'] ?? body['data'] ?? body['orders'] ?? [])
            : body;
        return content
            .map((item) => Order.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat order: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrder({
    required String customerName,
    required String description,
    required List<OrderItemRequest> orderDetails,
  }) async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.orders);

      final headers = <String, String>{'Content-Type': 'application/json'};

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final request = CreateOrderRequest(
        customerName: customerName,
        description: description,
        orderDetails: orderDetails,
      );

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'Gagal membuat order (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Method untuk mendapatkan revenue order
  Future<double> fetchOrderRevenue() async {
    try {
      final token = await AuthService.getToken();
      final url = Uri.parse(ApiConfig.orderRevenue);

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        return parseRevenue(body);
      } else {
        throw Exception('Gagal memuat revenue order: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
