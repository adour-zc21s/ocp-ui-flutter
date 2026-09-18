import 'package:flutter_test/flutter_test.dart';
import 'package:ocp_flut/models/device_model.dart';

void main() {
  test('reads passwordPortal from API response', () {
    final device = Device.fromJson({
      'id': 1,
      'deviceName': 'Router',
      'passwordPortal': 'portal-secret',
    });

    expect(device.passwordPortal, 'portal-secret');
  });

  test('keeps supporting snake_case password_portal', () {
    final device = Device.fromJson({'password_portal': 'legacy-secret'});

    expect(device.passwordPortal, 'legacy-secret');
  });
}
