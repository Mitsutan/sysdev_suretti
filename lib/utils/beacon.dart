import 'dart:async';
import 'dart:developer';

import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final beaconProvider = ChangeNotifierProvider((ref) => BeaconFunc());

class BeaconFunc extends ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<Map<String, dynamic>> _scanResults = [];

  late SharedPreferences prefs;
  bool isInitialized = false;

  // int major;
  // int minor;

  // constructor
  BeaconFunc() {
    _initialize();
  }

  Future<void> _initialize() async {
    prefs = await SharedPreferences.getInstance();
    isInitialized = true;
  }

  BluetoothAdapterState get adapterState => _adapterState;
  List<Map<String, dynamic>> get scanResults => _scanResults;

  BeaconBroadcast beacon = BeaconBroadcast();

  void updateAdapterState(BluetoothAdapterState newState) {
    _adapterState = newState;
    notifyListeners();
  }

  void updateScanResults(List<Map<String, dynamic>> newResults) {
    _scanResults = newResults;
    notifyListeners();
  }

  /// スキャンするビーコンのフィルター
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
    // log((await flutterBeacon.isBroadcasting()).toString(),
    //     name: 'flutterBeacon.isBroadcasting()');
    beacon.getAdvertisingStateChange().listen((isAdvertising) {
      // log('isAdvertising: $isAdvertising', name: 'beacon');
      debugPrint('isAdvertising: $isAdvertising');
    });

    try {
      debugPrint('Beacon Start!');

      debugPrint('major: $major, minor: $minor');

      await beacon
          .setUUID(const String.fromEnvironment("IBEACON_UUID"))
          .setMajorId(major)
          .setMinorId(minor)
          .setIdentifier('dev.mitsutan.sysdev_suretti')
          .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
          .setManufacturerId(0x004C)
          .start();
    } catch (e) {
      // log('Start broadcast error', name: 'beacon', error: e);
      debugPrint('Start broadcast error: $e');
    }

    // FBP start scan
    try {
      await FlutterBluePlus.startScan(
          withMsd: [_msdFilterData], androidUsesFineLocation: true);
    } catch (e) {
      // log('Start scan Err', name: 'beacon', error: e);
      debugPrint('Start scan Err: $e');
    }

    // debugPrint("isAd:${(await beacon.isAdvertising()).toString()}");

    // FBP scanResults listen
    FlutterBluePlus.scanResults.listen((results) async {
      final List<Map<String, dynamic>> resultsList = [];

      for (final result in results) {
        if (result.advertisementData.manufacturerData.isEmpty) {
          continue;
        }
        final major1 = result.advertisementData.manufacturerData.values.first
            .elementAt(18)
            .toRadixString(16);
        final major2 = result.advertisementData.manufacturerData.values.first
            .elementAt(19)
            .toRadixString(16);
        final minor1 = result.advertisementData.manufacturerData.values.first
            .elementAt(20)
            .toRadixString(16);
        final minor2 = result.advertisementData.manufacturerData.values.first
            .elementAt(21)
            .toRadixString(16);

        final id = int.parse('$major1$major2$minor1$minor2', radix: 16);

        try {
          await Supabase.initialize(
            url: const String.fromEnvironment("SUPABASE_URL"),
            anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
          );
        } on AssertionError catch (e) {
          log('Supabase initialize error', name: 'Supabase', error: e);
        }

        final supabase = Supabase.instance.client;
        try {
          await supabase
              .from('users')
              .select(
                  '*, messages!users_message_id_fkey(*)')
              .eq('user_id', id)
              .then((data) {
            resultsList.add(data.first);
            // log('msgData: $data');
            debugPrint('msgData: $data');
          });
        } catch (e) {
          log("get message fail", error: e, name: 'msgData');
        }
      }
      updateScanResults(resultsList);
    }, onError: (e) {
      log('Scan error', name: 'FlutterBluePlus', error: e);
    });
  }

  Future<void> stopBeacon() async {
    // flutterBeacon stop broadcast
    // log((await flutterBeacon.isBroadcasting()).toString(),
    //     name: 'flutterBeacon.isBroadcasting()');
    try {
      beacon.stop();
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

  Future<bool?> isBroadcasting() async {
    return await beacon.isAdvertising();
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
