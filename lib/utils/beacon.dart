import 'dart:async';
import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothState;
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final beaconProvider = ChangeNotifierProvider((ref) => BeaconFunc());

final bf = BeaconFunc();

// アプリがバックグラウンドで実行されている場合に実行されるタスク
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    log('Headless task timed-out: $taskId', name: 'BackgroundFetch');
    BackgroundFetch.finish(taskId);
    return;
  }
  log('Headless event received.', name: 'BackgroundFetch');
  // Do your work here...
  if (!bf.isScanning()) {
    bf.stopBeacon();
    bf.startBeacon(bf.major, bf.minor);
  }
  BackgroundFetch.finish(taskId);
}

class BeaconFunc extends ChangeNotifier {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  List<Map<String, dynamic>> _scanResults = [];

  int major = 1;
  int minor = 1;

  BluetoothAdapterState get adapterState => _adapterState;
  List<Map<String, dynamic>> get scanResults => _scanResults;

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
    log((await flutterBeacon.isBroadcasting()).toString(),
        name: 'flutterBeacon.isBroadcasting()');
    // try {
    //   await flutterBeacon.startBroadcast(BeaconBroadcast(
    //     proximityUUID: const String.fromEnvironment("IBEACON_UUID"),
    //     major: major,
    //     minor: minor,
    //     identifier: 'dev.mitsutan.sysdev_suretti',
    //   ));
    // } catch (e) {
    //   log('Start broadcast error', name: 'beacon', error: e);
    // }
    try {
      debugPrint('Beacon Start!');
      final status = await flutterBeacon.authorizationStatus;
      debugPrint(status.value);
      if (status.value == AuthorizationStatus.notDetermined.value) {
        final result = await flutterBeacon.bluetoothState;
        if (result.value == BluetoothState.stateOn.value) await flutterBeacon.initializeAndCheckScanning;
      } else {
        await flutterBeacon.initializeScanning;
      }
    } on PlatformException catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      // Sentry.captureException(e, stackTrace: s);
    }

    // FBP start scan
    try {
      await FlutterBluePlus.startScan(
          withMsd: [_msdFilterData], androidUsesFineLocation: true);
    } catch (e) {
      log('Start scan Err', name: 'beacon', error: e);
    }

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
        final supabase = Supabase.instance.client;
        try {
          await supabase
              .from('users')
              .select(
                  'nickname, icon, message_id, messages!users_message_id_fkey(message_id, message_text, post_timestamp)')
              .eq('user_id', id)
              .then((data) {
            resultsList.add(data.first);
            log('msgData: $data');
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
