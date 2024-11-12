import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';
import 'package:sysdev_suretti/utils/beacon.dart';

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
  debugPrint('Headless event received.');
  // Do your work here...
  final bf = BeaconFunc();

  while (!bf.isInitialized) {
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('Waiting for initialization...${bf.isInitialized}');
  }

  if (!bf.isScanning()) {
    bf.stopBeacon();
    bf.startBeacon(
        bf.prefs.getInt('major') ?? 1, bf.prefs.getInt('minor') ?? 1);
  }
  BackgroundFetch.finish(taskId);
}

/// エントリーポイント
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // ログの設定
  // void log(String level, String message) {
  //   debugPrint('$level: ${DateTime.now()}: $message');
  // }

  // try {
  //   // .env ファイルのロード
  //   await dotenv.load(fileName: ".env");
  //   log('INFO', '.env file loaded successfully');
  // } catch (e) {
  //   log('SEVERE', 'Failed to load .env file: $e');
  //   return;
  // }

  // final supabaseUrl = dotenv.env['SUPABASE_URL'];
  // final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  // if (supabaseUrl == null || supabaseAnonKey == null) {
  //   log('SEVERE', 'SUPABASE_URL or SUPABASE_ANON_KEY is not set in .env file');
  //   return;
  // }

  // Supabase初期化
  // await Supabase.initialize(
  //   url: supabaseUrl,
  //   anonKey: supabaseAnonKey,
  // );
  // mitsutan:dart標準の環境変数読込処理
  await Supabase.initialize(
    url: const String.fromEnvironment(
        "SUPABASE_URL"), // ここにSupabaseプロジェクトのURLを入力
    anonKey: const String.fromEnvironment(
        "SUPABASE_ANON_KEY"), // ここにSupabaseプロジェクトのanonキーを入力
  );

  // ログレベルの設定
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  runApp(const ProviderScope(child: MyApp()));

  // バックグラウンドタスクの登録
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// 各種権限リクエスト
  Future<void> requestPermission(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothAdvertise,
      Permission.bluetoothScan,
      // Permission.bluetoothConnect,
      Permission.locationWhenInUse,
      Permission.locationAlways,
      // Permission.bluetooth
    ].request();
    log(statuses.toString(), name: 'PermissionStatus');

    // 位置情報の許可が得られていない場合は、再度許可を求める
    if (statuses[Permission.locationAlways] != PermissionStatus.granted) {
      await Permission.locationWhenInUse.request();

      // ダイアログ表示
      // if (context.mounted) {
      //   await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: const Text('位置情報の許可'),
      //         content: const Text('位置情報（常時）の許可が必要です。設定画面を開きますか？'),
      //         actions: <Widget>[
      //           TextButton(
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //             child: const Text('キャンセル'),
      //           ),
      //           TextButton(
      //             onPressed: () async {
      //             },
      //             child: const Text('設定'),
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
      await Permission.locationAlways.request();
    }

    // Bluetoothの許可が得られていない場合は、再度許可を求める
    if (statuses[Permission.bluetoothAdvertise] != PermissionStatus.granted) {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    requestPermission(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Loading(),
    );
  }
}
