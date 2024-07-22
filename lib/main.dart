import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';

// エントリーポイント
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // ログの設定
  void log(String level, String message) {
    debugPrint('$level: ${DateTime.now()}: $message');
  }

  try {
    // .env ファイルのロード
    await dotenv.load(fileName: ".env");
    log('INFO', '.env file loaded successfully');
  } catch (e) {
    log('SEVERE', 'Failed to load .env file: $e');
    return;
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    log('SEVERE', 'SUPABASE_URL or SUPABASE_ANON_KEY is not set in .env file');
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  // mitsutan
  // await Supabase.initialize(
  //   url: 'https://jeluoazapxqjksdfvftm.supabase.co', // ここにSupabaseプロジェクトのURLを入力
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImplbHVvYXphcHhxamtzZGZ2ZnRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkxOTI0MTAsImV4cCI6MjAzNDc2ODQxMH0.T2OLrQzZrv3hvs2khmLdlFb72XE-m7QOJdqNhVmIges', // ここにSupabaseプロジェクトのanonキーを入力
  // );

  // ログレベルの設定
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);


  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> requestPermission() async {
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
      requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {

    requestPermission();
    
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
