
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:sysdev_suretti/pages/forget_loading.dart';
import 'package:sysdev_suretti/pages/loading.dart';
//import 'package:sysdev_suretti/pages/new_password.dart';
import 'package:sysdev_suretti/pages/new_password_screen.dart';
import 'package:sysdev_suretti/pages/reset_link_sent_screen.dart';
import 'package:sysdev_suretti/pages/reset_password_screen.dart';
import 'package:sysdev_suretti/services/auth_state_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:sysdev_suretti/utils/beacon.dart';
 
// アプリがバックグラウンドで実行されている場合に実行されるタスク
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    log('Headless task timed-out: $taskId', name: 'BackgroundFetch');
    BackgroundFetch.finish(taskId);
    return;
  }
  log('Headless event received.', name: 'BackgroundFetch');
  debugPrint('Headless event received.');
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
 
// エントリーポイント
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
 
  await Supabase.initialize(
    url: const String.fromEnvironment("SUPABASE_URL"),
    anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
  );
 
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
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
    log(statuses.toString(), name: 'PermissionStatus');
 
    if (statuses[Permission.locationAlways] != PermissionStatus.granted) {
      await Permission.locationAlways.request();
    }
 
    if (statuses[Permission.bluetoothAdvertise] != PermissionStatus.granted) {
      await Permission.bluetoothScan.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();
    }
  }
 
  @override
  Widget build(BuildContext context) {
    // requestPermission(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context){
          AuthStateHandler(context);
          return const AppInitializer();
        },
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => const AppInitializer(),
        '/loading': (context) => const Loading(),
        // '/forget_loading': (context) => const ForgetLoading(),
        '/new_password': (context) => const NewPasswordScreen(), // パスワード再設定画面
        '/reset-password': (context) => ResetPasswordScreen(),  // パスワード再設定画面
        '/reset-link-sent': (context) => ResetLinkSentScreen(),   // メール送信完了画面
      },
    );
  }
}
 
// 初期画面を判定するウィジェット
class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);
 
  @override
  _AppInitializerState createState() => _AppInitializerState();
}
 
class _AppInitializerState extends State<AppInitializer> with WidgetsBindingObserver {
  bool _initialized = false;
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleLinks();
  }
 
  Future<void> _handleLinks() async {
    try {
      // 起動時のリンク処理
      final initialLink = await getInitialLink();
      log('Initial link: $initialLink', name: 'AppInitializer');
      // アプリ起動中のリンク処理も同時に設定
      uriLinkStream.listen(
        (Uri? uri) async {
          final link = uri?.toString();
          log('Received link: $link', name: 'AppInitializer');
          if (link != null) {
            await _processRecoveryLink(link);
          }
        },
        onError: (err) {
          log('Link stream error: $err', name: 'AppInitializer');
        },
      );
 
      if (initialLink != null) {
        await _processRecoveryLink(initialLink);
      } else if (!_initialized) {
        _initialized = true;
        _navigateToDefault();
      }
    } catch (e) {
      log('Error in handleLinks: $e', name: 'AppInitializer');
      if (!_initialized) {
        _initialized = true;
        _navigateToDefault();
      }
    }
  }
 
Future<void> _processRecoveryLink(String link) async {
  if (!mounted) return;

  log('Processing link: $link', name: 'AppInitializer');
  try {
      final uri = Uri.parse(link);
      // リンクのすべての情報をログ出力
      log('URI scheme: ${uri.scheme}', name: 'AppInitializer');
      log('URI host: ${uri.host}', name: 'AppInitializer');
      log('URI path: ${uri.path}', name: 'AppInitializer');
      log('URI query parameters: ${uri.queryParameters}', name: 'AppInitializer');
  // パスワードリセット用のDeepLinkの場合
    if (uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code'];
      // if (mounted) {
      //   // すべての現在のルートをクリアして新しいパスワード画面に遷移
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => NewPasswordPage(accessToken: code),
      //     ),
      //     (route) => false,
      //   );
      // }
    }
  } catch (e) {
    log('Error processing recovery link: $e', name: 'AppInitializer');
  }
}
 
  void _navigateToDefault() {
    if (!mounted) return;
    log('Navigating to default route', name: 'AppInitializer');
    Navigator.pushReplacementNamed(context, '/loading');
  }
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
 
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}


// コンテキスト メニューあり
// import 'package:background_fetch/background_fetch.dart';
// import 'package:flutter/services.dart';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:sysdev_suretti/pages/forget_loading.dart'; // ForgetLoadingをインポート
// import 'package:sysdev_suretti/pages/loading.dart'; // Loadingをインポート
// import 'package:uni_links/uni_links.dart'; // Deep Link対応パッケージ
// import 'package:sysdev_suretti/utils/beacon.dart';

// // アプリがバックグラウンドで実行されている場合に実行されるタスク
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   if (isTimeout) {
//     log('Headless task timed-out: $taskId', name: 'BackgroundFetch');
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   log('Headless event received.', name: 'BackgroundFetch');
//   debugPrint('Headless event received.');
//   final bf = BeaconFunc();

//   while (!bf.isInitialized) {
//     await Future.delayed(const Duration(milliseconds: 100));
//     debugPrint('Waiting for initialization...${bf.isInitialized}');
//   }

//   if (!bf.isScanning()) {
//     bf.stopBeacon();
//     bf.startBeacon(
//         bf.prefs.getInt('major') ?? 1, bf.prefs.getInt('minor') ?? 1);
//   }
//   BackgroundFetch.finish(taskId);
// }

// // エントリーポイント
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   await Supabase.initialize(
//     url: const String.fromEnvironment("SUPABASE_URL"),
//     anonKey: const String.fromEnvironment("SUPABASE_ANON_KEY"),
//   );

//   FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

//   runApp(const ProviderScope(child: MyApp()));

//   // バックグラウンドタスクの登録
//   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   /// 各種権限リクエスト
//   Future<void> requestPermission(BuildContext context) async {
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.bluetoothAdvertise,
//       Permission.bluetoothScan,
//       Permission.locationWhenInUse,
//       Permission.locationAlways,
//     ].request();
//     log(statuses.toString(), name: 'PermissionStatus');

//     if (statuses[Permission.locationAlways] != PermissionStatus.granted) {
//       await Permission.locationAlways.request();
//     }

//     if (statuses[Permission.bluetoothAdvertise] != PermissionStatus.granted) {
//       await Permission.bluetoothScan.request();
//       await Permission.bluetoothAdvertise.request();
//       await Permission.bluetoothConnect.request();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     requestPermission(context);

//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       initialRoute: '/', // 初期ルートを設定
//       routes: {
//         '/': (context) => const AppInitializer(), // 初期画面
//         '/loading': (context) => const Loading(),
//         '/forget_loading': (context) => const ForgetLoading(),
//       },
//     );
//   }
// }

// // 初期画面を判定するウィジェット
// class AppInitializer extends StatefulWidget {
//   const AppInitializer({Key? key}) : super(key: key);

//   @override
//   _AppInitializerState createState() => _AppInitializerState();
// }

// class _AppInitializerState extends State<AppInitializer> {
//   @override
//   void initState() {
//     super.initState();
//     _checkInitialLink();
//   }

//   Future<void> _checkInitialLink() async {
//     try {
//       final String? initialLink = await getInitialLink();
//       if (initialLink != null && initialLink.contains('reset-password')) {
//         Navigator.pushReplacementNamed(context, '/forget_loading');
//       } else {
//         Navigator.pushReplacementNamed(context, '/loading');
//       }
//     } catch (e) {
//       log('Failed to get initial link: $e', name: 'AppInitializer');
//       Navigator.pushReplacementNamed(context, '/loading');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()), // 判定中はローディングを表示
//     );
//   }
// }
