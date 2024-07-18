import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';


// エントリーポイント
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterの初期化を確認
  // ishikawa
  await Supabase.initialize(
    url: 'https://vjhuodzsglhylvomzysa.supabase.co', // ここにSupabaseプロジェクトのURLを入力
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqaHVvZHpzZ2xoeWx2b216eXNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA0MDI2MzQsImV4cCI6MjAzNTk3ODYzNH0.BfStERksC0fhY8Vpu9979nBdZbOMIku16Pop-a-xgts', // ここにSupabaseプロジェクトのanonキーを入力
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

