// Stub implementation for non-web platforms
// This file is used when the conditional import resolves to non-web platforms

class DeviceIdentifierWeb {
  Future<String> getDeviceId() async {
    throw UnsupportedError('DeviceIdentifierWeb is only supported on web platforms');
  }
}