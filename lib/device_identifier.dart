import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Conditional imports for different platforms
import 'device_identifier_web.dart' if (dart.library.io) 'device_identifier_stub.dart';

class DeviceIdentifier {
  static const MethodChannel _channel =
      const MethodChannel('device_identifier');

  static Future<String> get deviceId async {
    // Check if running on web platform
    if (kIsWeb) {
      final webImplementation = DeviceIdentifierWeb();
      return await webImplementation.getDeviceId();
    }
    
    // For mobile platforms (Android/iOS), use the existing method channel
    return await _channel.invokeMethod('id');
  }
}
