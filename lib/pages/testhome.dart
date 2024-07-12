import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';
import 'package:sysdev_suretti/utils/beacon.dart';
import 'package:sysdev_suretti/utils/provider.dart';

class Testhome extends ConsumerWidget {
  const Testhome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beacon = ref.watch(beaconProvider);
    final userData = ref.watch(userDataProvider);

    // log(beacon.adapterState.toString(), name: 'BluetoothAdapterState');
    // beacon.getAdapterState().listen((state) {
    //   beacon.updateAdapterState(state);
    // });

    // final user = Supabase.instance.client.auth.currentUser;

    // usersテーブルからuser.auth_idをキーにしてユーザー情報を取得

    Future<List<Map<String, dynamic>>> getUserData() async {
      final userData = await Supabase.instance.client
          .from('users')
          .select()
          .eq('auth_id', Supabase.instance.client.auth.currentUser!.id);
      return userData;
    }

    // Future<List<Map<String, dynamic>>> userData = getUserData();
    getUserData().asStream().listen((event) {
      log(event.toString());
      userData.updateNickname(event[0]['nickname']);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Testhome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(user!.userMetadata!['username'].toString()),
            Text(userData.nickname),
            TextButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const Loading();
                  }), (route) => false);
                },
                child: const Text('Logout')),
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
