import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/models/scanned_user.dart';
import 'package:sysdev_suretti/pages/loading.dart';
import 'package:sysdev_suretti/utils/beacon.dart';
import 'package:sysdev_suretti/utils/lifecycle.dart';
import 'package:sysdev_suretti/utils/provider.dart';
import 'package:sysdev_suretti/utils/sqlite.dart';

class Testhome extends ConsumerWidget {
  const Testhome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beacon = ref.watch(beaconProvider);
    final userData = ref.watch(userDataProvider);

    final Sqlite sqlite = Sqlite(Supabase.instance.client.auth.currentUser!.id);

    ref.listen<AppLifecycleState>(appLifecycleProvider, (previous, next) {
      if (next == AppLifecycleState.resumed) {
        if (!beacon.isScanning()) {
          beacon.stopBeacon();
          beacon.startBeacon(beacon.major, beacon.minor);
        }
      }
    });

    // Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    //   final AuthChangeEvent event = data.event;
    //   if (event == AuthChangeEvent.signedOut) {
    //     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) {
    //       return const Loading();
    //     }), (route) => false);
    //   }
    // });

    // log(beacon.adapterState.toString(), name: 'BluetoothAdapterState');
    // beacon.getAdapterState().listen((state) {
    //   beacon.updateAdapterState(state);
    // });

    // final user = Supabase.instance.client.auth.currentUser;

    // usersテーブルからuser.auth_idをキーにしてユーザー情報を取得
    Future<void> getUserData() async {
      final user = await Supabase.instance.client
          .from('users')
          .select()
          .eq('auth_id', Supabase.instance.client.auth.currentUser!.id);
      log(user.toString());
      userData.updateNickname(user.first['nickname']);
      String userId = user.first['user_id'].toRadixString(16).padLeft(8, '0');
      beacon.major = int.parse(userId.substring(0, 4), radix: 16);
      beacon.minor = int.parse(userId.substring(4, 8), radix: 16);

      userData.updateIsGotUserData(true);
    }

    if (!userData.isGotUserData) {
      try {
        getUserData();
      } catch (e) {
        log(e.toString());
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Loading();
        }), (route) => false);
      }
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
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
                    userData.updateIsGotUserData(false);
                    Navigator.of(context, rootNavigator: true)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                      return const Loading();
                    }), (route) => false);
                  },
                  child: const Text('Logout')),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Major'),
              //   onChanged: (value) => beacon.major = int.parse(value),
              //   keyboardType: TextInputType.number,
              // ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Minor'),
              //   onChanged: (value) => beacon.minor = int.parse(value),
              //   keyboardType: TextInputType.number,
              // ),
              ElevatedButton(
                  onPressed: () {
                    sqlite.deleteDatabase(
                        Supabase.instance.client.auth.currentUser!.id);
                  },
                  child: const Text('delete table')),
              const Text('Scanned devices:'),
              if (Platform.isIOS) ...[
                  ListView.builder(
                    itemCount: beacon.scanResultsiOS.length,
                    itemBuilder: (context, index) {
                      final result = beacon.scanResultsiOS[index];
                      return ListTile(
                        title: Text(result.identifier),
                        subtitle: Text('${result.major.toString()}${result.minor.toString()}'),
                      );
                    },
                  )
                ],
              Expanded(
                child: ListView.builder(
                  itemCount: beacon.scanResults.length,
                  itemBuilder: (context, index) {
                    final result = beacon.scanResults[index];
                    final major1 = result
                        .advertisementData.manufacturerData.values.first
                        .elementAt(18)
                        .toRadixString(16);
                    final major2 = result
                        .advertisementData.manufacturerData.values.first
                        .elementAt(19)
                        .toRadixString(16);
                    final minor1 = result
                        .advertisementData.manufacturerData.values.first
                        .elementAt(20)
                        .toRadixString(16);
                    final minor2 = result
                        .advertisementData.manufacturerData.values.first
                        .elementAt(21)
                        .toRadixString(16);
                    log('major: $major1$major2, minor: $minor1$minor2');
                    sqlite.insertScanedUser(ScannedUser(
                        userId: int.parse('$major1$major2$minor1$minor2',
                            radix: 16),
                        scannedAt: DateTime.now(),
                        isGotPost: false));
                    log(result.advertisementData.manufacturerData.values
                        .toString());
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
}
