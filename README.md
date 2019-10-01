# device_identifier

[![pub package](https://img.shields.io/pub/v/device_identifier.svg)](https://pub.dartlang.org/packages/device_identifier)

A Flutter plugin for iOS and Android to get the unique device identifier.

Uses `identifierForVendor` for iOS and `ANDROID_ID` for Android.

### Example

``` dart
import 'package:device_identifier/device_identifier.dart';

final deviceIdentifier = await DeviceIdentifier.id;
```

