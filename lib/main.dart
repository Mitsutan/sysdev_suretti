import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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

  // Supabase の初期化
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // ログレベルの設定
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  // Flutter アプリの実行
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
