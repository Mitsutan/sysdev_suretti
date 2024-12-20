import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/utils/beacon.dart';
import 'package:sysdev_suretti/utils/display_time.dart';
import 'package:sysdev_suretti/utils/post_card.dart';
// import 'package:sysdev_suretti/utils/lifecycle.dart';
import 'package:sysdev_suretti/utils/provider.dart';
// import 'package:sysdev_suretti/utils/sqlite.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beacon = ref.watch(beaconProvider);
    final udp = ref.watch(userDataProvider);

    // Platform messages are asynchronous, so we initialize in an async method.
    Future<void> initPlatformState() async {
      // Configure BackgroundFetch.
      int status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
              minimumFetchInterval: 15,
              stopOnTerminate: false,
              enableHeadless: true,
              startOnBoot: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY), (String taskId) async {
        // <-- Event handler
        // This is the fetch-event callback.
        log("Event received $taskId", name: 'BackgroundFetch');
        // setState(() {
        //   _events.insert(0, new DateTime.now());
        // });
        if (!beacon.isScanning()) {
          beacon.stopBeacon();
          beacon.startBeacon(beacon.prefs.getInt('major') ?? 1,
              beacon.prefs.getInt('minor') ?? 1);
        }
        // IMPORTANT:  You must signal completion of your task or the OS can punish your app
        // for taking too long in the background.
        BackgroundFetch.finish(taskId);
      }, (String taskId) async {
        // <-- Task timeout handler.
        // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
        if (!beacon.isScanning()) {
          beacon.stopBeacon();
        }
        log("TASK TIMEOUT taskId: $taskId", name: 'BackgroundFetch');
        BackgroundFetch.finish(taskId);
      });
      log('configure success: $status', name: 'BackgroundFetch');
      // setState(() {
      //   _status = status;
      // });

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      // if (!mounted) return;
    }

    initPlatformState();

    // final Sqlite sqlite = Sqlite(supabase.auth.currentUser!.id);

    // ライフサイクル取得：ビーコンスキャン中ではない場合、スキャン開始
    // ref.listen<AppLifecycleState>(appLifecycleProvider, (previous, next) {
    //   log("previous: ${previous.toString()}, next: ${next.toString()}", name: 'AppLifecycleState');
    //   if (next == AppLifecycleState.resumed) {
    //     if (!beacon.isScanning()) {
    //       beacon.stopBeacon();
    //       beacon.startBeacon(beacon.prefs.getInt('major') ?? 1,
    //           beacon.prefs.getInt('minor') ?? 1);
    //     }
    //   }
    // });

    // ユーザー情報未取得の場合ローディングインジケーターを表示
    if (udp.userData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('ホーム'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // 設定画面へ遷移する処理をここに追加
              },
            ),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: beacon.scanResults.length, // アイテムの数を設定
          itemBuilder: (context, index) {
            final result = beacon.scanResults[index];
            return PostCard(
                selfUserId: udp.userData['user_id'],
                username: result['nickname'],
                date: diffTime(DateTime.now(),
                    DateTime.parse(result['messages']['post_timestamp'])),
                userid: result['user_id'],
                iconpath: result['icon'],
                message: result['messages']['message_text'],
                messageId: result['messages']['message_id'],
                recommend: result['messages']['recommended_place'],
                address: result['messages']['address'],
                location: result['messages']['location'],
                isEditable: false);
          },
        ),
        // bottomNavigationBar: BottomAppBar(
        //   shape: const CircularNotchedRectangle(),
        //   notchMargin: 6.0,
        //   child: Row(
        //     mainAxisSize: MainAxisSize.max,
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: <Widget>[
        //       IconButton(
        //         icon: const Icon(Icons.home),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.search),
        //         onPressed: () {},
        //       ),
        //       const SizedBox(width: 40), // 中央のボタンのスペース
        //       IconButton(
        //         icon: const Icon(Icons.notifications),
        //         onPressed: () {},
        //       ),
        //       IconButton(
        //         icon: const Icon(Icons.person),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   tooltip: '投稿',
        //   backgroundColor: Colors.blue,
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButton: beacon.isScanning()
            ? FloatingActionButton(
                onPressed: () {
                  beacon.stopBeacon();
                },
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              )
            : FloatingActionButton(
                onPressed: () async {
                  await beacon.startBeacon(beacon.prefs.getInt('major') ?? 1,
                      beacon.prefs.getInt('minor') ?? 1);
                },
                child: const Text("SCAN"),
              ),
      );
    }
  }
}
