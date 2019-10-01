#import "DeviceIdentifierPlugin.h"
#import <device_identifier/device_identifier-Swift.h>

@implementation DeviceIdentifierPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDeviceIdentifierPlugin registerWithRegistrar:registrar];
}
@end
