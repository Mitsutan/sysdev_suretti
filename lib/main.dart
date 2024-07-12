// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sysdev_suretti/pages/loading.dart';



final Logger _logger = Logger('MyAppLogger');
// エントリーポイント
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ログの設定
  _logger.level = Level.FINEST;
  _logger.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  try {
    await dotenv.load(fileName: ".env");
    _logger.info('.env file loaded successfully');
  } catch (e) {
    _logger.severe('Failed to load .env file', e);
    return;
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    _logger.severe('SUPABASE_URL or SUPABASE_ANON_KEY is not set in .env file');
    return;
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
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

