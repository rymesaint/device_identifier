import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:device_identifier/device_identifier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceId = 'Unknown';

  @override
  void initState() {
    super.initState();
    initDeviceIdState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDeviceIdState() async {
    String deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await DeviceIdentifier.deviceId;
    } on PlatformException {
      deviceId = 'Failed to get device id.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device ID example app'),
        ),
        body: Center(
          child: Text('Running on: $_deviceId\n'),
        ),
      ),
    );
  }
}
