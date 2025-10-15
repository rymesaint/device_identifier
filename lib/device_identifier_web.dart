import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

/// Web implementation of the DeviceIdentifier plugin.
class DeviceIdentifierWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'device_identifier',
      const StandardMethodCodec(),
      registrar,
    );

    final DeviceIdentifierWeb instance = DeviceIdentifierWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'id':
        return await getDeviceId();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'device_identifier for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Gets a unique device identifier for web browsers.
  /// This implementation uses a combination of browser fingerprinting
  /// and localStorage to create a persistent unique identifier that remains
  /// the same across browser sessions.
  Future<String> getDeviceId() async {
    try {
      // First, try to get existing ID from localStorage
      final storage = window.localStorage;
      const storageKey = 'device_identifier_web_id';

      String? existingId = storage.getItem(storageKey);
      if (existingId != null && existingId.isNotEmpty) {
        return existingId;
      }

      // Generate a deterministic unique identifier based on browser characteristics
      final fingerprint = await _generateBrowserFingerprint();

      // Create a deterministic hash from the fingerprint (no timestamp or random)
      final bytes = utf8.encode(fingerprint);
      final hash = _simpleHash(bytes);

      final deviceId = 'web_${hash.abs().toString()}';

      // Store the generated ID in localStorage for persistence
      storage.setItem(storageKey, deviceId);

      return deviceId;
    } catch (e) {
      // Fallback: generate a deterministic ID based on basic browser info
      final fallbackId = await _generateFallbackId();
      try {
        window.localStorage.setItem('device_identifier_web_id', fallbackId);
      } catch (_) {
        // If localStorage is not available, just return the fallback ID
      }
      return fallbackId;
    }
  }

  /// Generates a browser fingerprint based on available characteristics.
  Future<String> _generateBrowserFingerprint() async {
    final characteristics = <String>[];

    try {
      // User agent
      characteristics.add(window.navigator.userAgent);

      // Screen resolution
      characteristics.add('${window.screen.width}x${window.screen.height}');

      // Available screen size (using available properties)
      final screen = window.screen;
      characteristics.add('${screen.width}x${screen.height}');

      // Color depth
      characteristics.add('${window.screen.colorDepth}');

      // Pixel depth
      characteristics.add('${window.screen.pixelDepth}');

      // Timezone offset
      characteristics.add('${DateTime.now().timeZoneOffset.inMinutes}');

      // Language
      characteristics.add(window.navigator.language);

      // Platform
      characteristics.add(window.navigator.platform);

      // Cookie enabled
      characteristics.add('${window.navigator.cookieEnabled}');

      // Do not track (using js interop to access property)
      try {
        final navigatorJS = window.navigator as JSObject;
        final doNotTrack = navigatorJS.getProperty('doNotTrack'.toJS);
        characteristics.add('${doNotTrack ?? ''}');
      } catch (_) {
        characteristics.add('');
      }

      // Hardware concurrency (number of CPU cores)
      try {
        final hardwareConcurrency = window.navigator.hardwareConcurrency;
        characteristics.add('$hardwareConcurrency');
      } catch (_) {
        // Hardware concurrency not available
      }

      // Device memory (if available)
      try {
        final navigatorJS = window.navigator as JSObject;
        final deviceMemory = navigatorJS.getProperty('deviceMemory'.toJS);
        if (deviceMemory != null) {
          characteristics.add('$deviceMemory');
        }
      } catch (_) {
        // Device memory not available
      }

      // Canvas fingerprint (simplified)
      try {
        final canvas = HTMLCanvasElement();
        canvas.width = 200;
        canvas.height = 50;
        final ctx = canvas.getContext('2d') as CanvasRenderingContext2D;
        ctx.textBaseline = 'top';
        ctx.font = '14px Arial';
        ctx.fillText('Device Identifier Fingerprint 🔒', 2, 2);
        characteristics.add(canvas.toDataURL());
      } catch (_) {
        // Canvas fingerprinting failed, skip
      }
    } catch (_) {
      // If any characteristic gathering fails, continue with what we have
    }

    return characteristics.join('|');
  }

  /// Generates a deterministic fallback ID based on basic browser characteristics.
  /// This is used when the main fingerprinting fails but still needs to be persistent.
  Future<String> _generateFallbackId() async {
    try {
      final basicInfo = <String>[];

      // Use only the most stable browser characteristics for fallback
      basicInfo.add(window.navigator.userAgent);
      basicInfo.add(window.navigator.language);
      basicInfo.add(window.navigator.platform);
      basicInfo.add('${window.screen.width}x${window.screen.height}');

      final fallbackFingerprint = basicInfo.join('|');
      final bytes = utf8.encode(fallbackFingerprint);
      final hash = _simpleHash(bytes);

      return 'web_fallback_${hash.abs().toString()}';
    } catch (e) {
      // Ultimate fallback - use a fixed string that will be the same for this browser
      // This is not ideal but ensures some level of persistence
      return 'web_ultimate_fallback_${window.navigator.userAgent.hashCode.abs()}';
    }
  }

  /// Simple hash function for generating consistent hashes from strings.
  int _simpleHash(List<int> bytes) {
    int hash = 0;
    for (int byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xFFFFFFFF;
    }
    return hash;
  }
}
