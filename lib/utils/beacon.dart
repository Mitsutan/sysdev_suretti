import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

class BeaconFunc {
  final MsdFilter _msdFilterData = MsdFilter(76, data: [
    0x02,
    0x15,
    0x66,
    0x0e,
    0x33,
    0x2e,
    0x32,
    0x66,
    0x43,
    0x48,
    0xb8,
    0x8d,
    0x32,
    0x29,
    0x7b,
    0x15,
    0x94,
    0x5c
  ], mask: [
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    1
  ]);

  Future<void> startBeacon(int major, int minor) async {
    // flutterBeacon start broadcast
    log((await flutterBeacon.isBroadcasting()).toString(),
        name: 'flutterBeacon.isBroadcasting()');
    try {
      await flutterBeacon.startBroadcast(BeaconBroadcast(
        proximityUUID: const String.fromEnvironment("IBEACON_UUID"),
        major: major,
        minor: minor,
        identifier: 'dev.mitsutan.sysdev_suretti',
      ));
    } catch (e) {
      log('Start broadcast error', name: 'beacon', error: e);
    }

    // FBP start scan
    try {
      await FlutterBluePlus.startScan(
          withMsd: [_msdFilterData], androidUsesFineLocation: true);
    } catch (e) {
      log('Start scan Err', name: 'beacon', error: e);
    }
  }

  Future<void> stopBeacon() async {
    // flutterBeacon stop broadcast
    log((await flutterBeacon.isBroadcasting()).toString(),
        name: 'flutterBeacon.isBroadcasting()');
    try {
      await flutterBeacon.stopBroadcast();
    } catch (e) {
      log('Stop broadcast error', name: 'beacon', error: e);
    }

    // FBP stop scan
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      log('Stop scan Err', name: 'beacon', error: e);
    }
  }

  Future<bool> isBroadcasting() async {
    return await flutterBeacon.isBroadcasting();
  }

  bool isScanning() {
    return FlutterBluePlus.isScanningNow;
  }

  Stream<BluetoothAdapterState> getAdapterState() {
    return FlutterBluePlus.adapterState;
  }

  Stream<List<ScanResult>> getScanResults() {
    return FlutterBluePlus.scanResults;
  }
}
