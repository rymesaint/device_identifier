import Flutter
import UIKit

public class SwiftDeviceIdentifierPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_identifier", binaryMessenger: registrar.messenger())
    let instance = SwiftDeviceIdentifierPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "id") {
      result(UIDevice.current.identifierForVendor!.uuidString)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
