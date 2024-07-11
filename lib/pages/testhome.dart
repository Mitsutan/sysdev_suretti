import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sysdev_suretti/utils/beacon.dart';

class Testhome extends StatefulWidget {
  const Testhome({super.key});

  final String title = 'Testhome';

  @override
  State<Testhome> createState() => _TesthomeState();
}

class _TesthomeState extends State<Testhome> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  List<ScanResult> _scanResults = [];

  int _major = 1;
  int _minor = 1;

  final beacon = BeaconFunc();

  @override
  void initState() {
    super.initState();
    // flutterBeacon.initializeAndCheckScanning;

    FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });

    FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      log('Scan error', name: 'FlutterBluePlus', error: e);
    });
  }

  Widget buildScanButton(BuildContext context) {
    if (beacon.isScanning()) {
      return FloatingActionButton(
        onPressed: () {
          beacon.stopBeacon();
          if (mounted) {
            setState(() {});
          }
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.stop),
      );
    } else {
      return FloatingActionButton(
          onPressed: () {
            beacon.startBeacon(_major, _minor);
          },
          child: const Text("SCAN"));
    }
  }

  @override
  Widget build(BuildContext context) {
    log(_adapterState.toString(), name: 'BluetoothAdapterState');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Major'),
              onChanged: (value) => _major = int.parse(value),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Minor'),
              onChanged: (value) => _minor = int.parse(value),
              keyboardType: TextInputType.number,
            ),
            const Text('Scanned devices:'),
            Expanded(
              child: ListView.builder(
                itemCount: _scanResults.length,
                itemBuilder: (context, index) {
                  final result = _scanResults[index];
                  return ListTile(
                    title: Text(result.device.remoteId.toString()),
                    subtitle: Text(
                        result.advertisementData.manufacturerData.toString()),
                    trailing: Text('${result.rssi}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildScanButton(context),
    );
  }
}
