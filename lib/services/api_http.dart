import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/login_screen.dart';
import 'app_navigator.dart';
import 'auth_service.dart';

class ApiHttp {
  static bool _handlingUnauthorized = false;

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    return _handleResponse(await http.get(url, headers: headers));
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _handleResponse(await http.post(url, headers: headers, body: body));
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _handleResponse(await http.put(url, headers: headers, body: body));
  }

  static Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode == 401 && !_handlingUnauthorized) {
      _handlingUnauthorized = true;
      await AuthService().logout();

      final navigator = AppNavigator.navigatorKey.currentState;
      if (navigator != null) {
        navigator.pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
      _handlingUnauthorized = false;
    }

    return response;
  }
}

Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
    ApiHttp.get(url, headers: headers);

Future<http.Response> post(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
}) => ApiHttp.post(url, headers: headers, body: body);

Future<http.Response> put(
  Uri url, {
  Map<String, String>? headers,
  Object? body,
}) => ApiHttp.put(url, headers: headers, body: body);
