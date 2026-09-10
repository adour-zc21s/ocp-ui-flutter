import 'package:flutter_test/flutter_test.dart';
import 'package:ocp_flut/models/auth_model.dart';

void main() {
  test('login request should send identifier and password', () {
    final request = LoginRequest(identifier: 'admin01', password: 'secret123');

    expect(request.toJson(), {
      'identifier': 'admin01',
      'password': 'secret123',
    });
  });
}
