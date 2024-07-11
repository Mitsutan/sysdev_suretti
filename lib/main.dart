// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/loading.dart';


// エントリーポイント
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterの初期化を確認
  await Supabase.initialize(
    url: 'https://vjhuodzsglhylvomzysa.supabase.co', // ここにSupabaseプロジェクトのURLを入力
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZqaHVvZHpzZ2xoeWx2b216eXNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjA0MDI2MzQsImV4cCI6MjAzNTk3ODYzNH0.BfStERksC0fhY8Vpu9979nBdZbOMIku16Pop-a-xgts', // ここにSupabaseプロジェクトのanonキーを入力
  );

  // ログレベルの設定
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

