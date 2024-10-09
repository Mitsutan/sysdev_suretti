import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';
import 'package:sysdev_suretti/utils/beacon.dart';
import 'package:sysdev_suretti/utils/diff_time.dart';
import 'package:sysdev_suretti/utils/lifecycle.dart';
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
    final userData = ref.watch(userDataProvider);

    final supabase = Supabase.instance.client;

    // final Sqlite sqlite = Sqlite(supabase.auth.currentUser!.id);

    // ライフサイクル取得：ビーコンスキャン中ではない場合、スキャン開始
    ref.listen<AppLifecycleState>(appLifecycleProvider, (previous, next) {
      if (next == AppLifecycleState.resumed) {
        if (!beacon.isScanning()) {
          beacon.stopBeacon();
          beacon.startBeacon(beacon.major, beacon.minor);
        }
      }
    });

    // usersテーブルからuser.auth_idをキーにしてユーザー情報を取得
    Future<void> getUserData() async {
      final user = await supabase
          .from('users')
          .select()
          .eq('auth_id', supabase.auth.currentUser!.id);
      log(user.toString());
      userData.updateUserData(user.first);
      String userId = user.first['user_id'].toRadixString(16).padLeft(8, '0');
      beacon.major = int.parse(userId.substring(0, 4), radix: 16);
      beacon.minor = int.parse(userId.substring(4, 8), radix: 16);

      userData.updateIsGotUserData(true);
    }

    // ユーザー情報未取得の場合：情報取得を試み、その間ローディングインジケーターを表示
    // なんらかの理由で例外が発生した場合、Loadingへ遷移
    // ユーザー情報取得済みの場合：ホーム画面構築
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
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          foregroundImage: NetworkImage(
                              "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${result['icon']}"),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result['nickname'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                             Text(
                              // result['messages']['post_timestamp'],
                              diffTime(DateTime.now(), DateTime.parse(result['messages']['post_timestamp'])),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // 追加の操作を表示する処理をここに追加
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(result['messages']['message_text']),
                    const SizedBox(height: 8.0),
                    Image.network('https://via.placeholder.com/150'), // サンプル画像
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        // TextButton.icon(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.reply, color: Colors.blue),
                        //   label: Text('返信', style: TextStyle(color: Colors.blue)),
                        // ),
                        // Spacer(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up, color: Colors.grey),
                          label: const Text('いいね',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 16.0),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_border,
                              color: Colors.grey),
                          label: const Text('ブックマーク',
                              style: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(width: 16.0),
                        TextButton.icon(
                          onPressed: () {},
                          icon:
                              const Icon(Icons.visibility, color: Colors.grey),
                          label: const Text('表示',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
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
                onPressed: () {
                  beacon.startBeacon(beacon.major, beacon.minor);
                },
                child: const Text("SCAN"),
              ),
      );
    }
  }
}
