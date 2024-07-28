import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final beaconProvider = ChangeNotifierProvider((ref) => BeaconFunc());

class BeaconFunc extends ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<ScanResult> _scanResults = [];
  List<Region> _scanResultsiOS = [];

  int major = 1;
  int minor = 1;

  BluetoothAdapterState get adapterState => _adapterState;
  List<ScanResult> get scanResults => _scanResults;
  List<Region> get scanResultsiOS => _scanResultsiOS;

  void updateAdapterState(BluetoothAdapterState newState) {
    _adapterState = newState;
    notifyListeners();
  }

  void updateScanResults(List<ScanResult> newResults) {
    _scanResults = newResults;
    notifyListeners();
  }

  void updateScanResultsiOS(Region newResults) {
    _scanResultsiOS.add(newResults);
    notifyListeners();
  }

  final MsdFilter _msdFilterData = MsdFilter(76, data: [
    0x02,
    0x15,
    0x97,
    0xb7,
    0x57,
    0x1b,
    0x57,
    0x18,
    0xbc,
    0x11,
    0xa7,
    0xd3,
    0x86,
    0x02,
    0x4c,
    0xda,
    0x3b,
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
    final regions = <Region>[];
    try {
      if (Platform.isIOS) {
        regions.add(Region(
            identifier: 'dev.mitsutan.sysdev_suretti',
            proximityUUID: const String.fromEnvironment("IBEACON_UUID")));
      } else {
        await FlutterBluePlus.startScan(
            withMsd: [_msdFilterData], androidUsesFineLocation: true);
      }
    } catch (e) {
      log('Start scan Err', name: 'beacon', error: e);
    }

    if (Platform.isIOS) {
      flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
        log(result.toString(), name: 'flutterBeacon.monitoring()');
        updateScanResultsiOS(result.region);
      }, onError: (e) {
        log('Monitoring error', name: 'flutterBeacon', error: e);
      });
    } else {
      // FBP scanResults listen
      FlutterBluePlus.scanResults.listen((results) {
        updateScanResults(results);
      }, onError: (e) {
        log('Scan error', name: 'FlutterBluePlus', error: e);
      });
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

    notifyListeners();
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
