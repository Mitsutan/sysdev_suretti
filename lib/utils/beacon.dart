import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_beacon/flutter_beacon.dart';


class StartBeacon {
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

  Future<void> startBeaconFunc(int major, int minor) async {
    // flutterBeacon start broadcast
    log((await flutterBeacon.isBroadcasting()).toString(),
        name: 'flutterBeacon.isBroadcasting()');
    try {
      await flutterBeacon.startBroadcast(BeaconBroadcast(
        proximityUUID: const String.fromEnvironment("IBEACON_UUID"),
        major: major,
        minor: minor,
        identifier: 'dev.mitsutan.sysdev_suretti_flutter',
      ));
    } catch (e) {
      log('Start broadcast error', name: 'flutterBeacon', error: e);
    }

    // FBP start scan
    try {
      await FlutterBluePlus.startScan(
          withMsd: [_msdFilterData], androidUsesFineLocation: true);
    } catch (e) {
      log('Start Beacon Err', name: 'startBeaconFunc', error: e);
    }
  }
}
