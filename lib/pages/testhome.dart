import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/utils/beacon.dart';

class Testhome extends ConsumerWidget {
  const Testhome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beacon = ref.watch(beaconProvider);

    // log(beacon.adapterState.toString(), name: 'BluetoothAdapterState');
    // beacon.getAdapterState().listen((state) {
    //   beacon.updateAdapterState(state);
    // });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Testhome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Major'),
              onChanged: (value) => beacon.major = int.parse(value),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Minor'),
              onChanged: (value) => beacon.minor = int.parse(value),
              keyboardType: TextInputType.number,
            ),
            const Text('Scanned devices:'),
            Expanded(
              child: ListView.builder(
                itemCount: beacon.scanResults.length,
                itemBuilder: (context, index) {
                  final result = beacon.scanResults[index];
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
      floatingActionButton: beacon.isScanning()
          ? FloatingActionButton(
              onPressed: () {
                beacon.stopBeacon();
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            )
          : FloatingActionButton(
              onPressed: () {
                beacon.startBeacon(beacon.major, beacon.minor);
              },
              child: const Text("SCAN"),
            ),
    );
  }
}