import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orders_model.dart';
import '../models/item_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class OrderService {
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
}
