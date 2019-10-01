import 'dart:async';

import 'package:flutter/services.dart';

class DeviceIdentifier {
  static const MethodChannel _channel =
      const MethodChannel('device_identifier');

  static Future<String> get deviceId async {
    return await _channel.invokeMethod('id');
  }
}
