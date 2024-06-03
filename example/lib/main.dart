import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:save_us_galaxy/galaxy.dart';
import 'package:save_us_galaxy/galaxy_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _galaxyPlugin = Galaxy();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _galaxyPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    // await startScan();

    // TODO Galaxy Health Connect API
    connectHealthAPI();
  }

  connectHealthAPI() async {
    var status = await GalaxyPlatform.instance.getSdkStatus();

    if (kDebugMode) {
      print('getSdkStatus:: $status');
    }
    if (status == 2) {
      await _openHealthConnect();
    }
  }

  Future _openHealthConnect() async {
    final uri = Uri.parse(
        "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> startScan() async {
    FlutterBluePlus.events.onMtuChanged.listen((event) async {
      for (final ds in await event.device.discoverServices()) {
        if (kDebugMode) {
          print('serviceUuid:: ${ds.serviceUuid.str128}');
        }
        if (ds.serviceUuid == Guid('0000180D-0000-1000-8000-00805F9B34FB')) {
          for (final dc in ds.characteristics) {
            if (kDebugMode) {
              print('characteristics:: ${dc.characteristicUuid.str128}');
            }
            if (dc.characteristicUuid ==
                Guid('00002A37-0000-1000-8000-00805F9B34FB')) {
              await dc.setNotifyValue(true);
            }
          }
        }
      }
    });
    FlutterBluePlus.events.onDiscoveredServices.listen((event) async {
      if (kDebugMode) {
        print('onDiscoveredServices:: ${event.services}');
      }
    });
    FlutterBluePlus.events.onCharacteristicWritten.listen((event) {
      if (kDebugMode) {
        print('onCharacteristicWritten:: ${event.value}');
      }
    });
    FlutterBluePlus.events.onDescriptorWritten.listen((event) {});
    FlutterBluePlus.events.onConnectionStateChanged.listen((event) {});
    FlutterBluePlus.events.onCharacteristicReceived.listen((event) {
      if (kDebugMode) {
        print('onCharacteristicReceived:: ${event.value}');
      }
    });
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.advName.startsWith('Galaxy')) {
          await FlutterBluePlus.stopScan();

          connectToDevice(r.device);

          repeat = false;
          break;
        }
        if (r.device.advName.isEmpty) {
          continue;
        }
        if (devices.any((e) => e.advName == r.device.advName)) {
          continue;
        }
        if (kDebugMode) {
          print({
            r.advertisementData.advName,
            r.advertisementData.manufacturerData
          });
        }
        devices.add(r.device);
      }
    });
    const duration = Duration(seconds: 9);

    while (repeat) {
      await FlutterBluePlus.startScan(timeout: duration, withMsd: [
        // SAMSUNG
        MsdFilter(0x0075),

        // Galaxy Fit3
        MsdFilter(0x0075,
            data: [1, 0, 2, 0, 1, 3, 255, 0, 0, 67, 42, 2, 10, 21, 232, 5])
      ]);

      await Future.delayed(duration);
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();

    setState(() {
      connectedDevice = device;
      _platformVersion = device.advName;
    });
  }

  Future discoverServices() async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();

    setState(() {
      this.services = services;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  BluetoothDevice? connectedDevice;
  List<BluetoothService> services = [];

  List<BluetoothDevice> devices = [];

  bool repeat = true;
}
