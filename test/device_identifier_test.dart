import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_identifier/device_identifier.dart';

void main() {
  const MethodChannel channel = MethodChannel('device_identifier');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getDeviceId', () async {
    expect(await DeviceIdentifier.deviceId, '42');
  });
}
