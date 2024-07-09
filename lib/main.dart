// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/testpage1.dart';
import 'pages/testpage2.dart';

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

// タブメニューに表示するページ情報
enum Pages {
  page1(
    title: 'page1',
    page: TestPage1(),
  ),
  page2(
    title: 'page2',
    page: TestPage2(),
  );

  const Pages({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}

final _navigatorKeys = <Pages, GlobalKey<NavigatorState>>{
  Pages.page1: GlobalKey<NavigatorState>(),
  Pages.page2: GlobalKey<NavigatorState>(),
};

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
      home: const Navigation(),
    );
  }
}

// ナビゲーターウィジェット
class Navigation extends HookWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab = useState(Pages.page1);

    return Scaffold(
        body: Stack(
          children: Pages.values
              .map((page) => Offstage(
                    offstage: currentTab.value != page,
                    child: Navigator(
                      key: _navigatorKeys[page],
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (context) => page.page,
                        );
                      },
                    ),
                  ))
              .toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: Pages.values.indexOf(currentTab.value),
          items: Pages.values
              .map((page) => BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: page.title,
                  ))
              .toList(),
          onTap: (index) {
            final selectedTab = Pages.values[index];
            if (currentTab.value == selectedTab) {
              _navigatorKeys[selectedTab]
                  ?.currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              currentTab.value = selectedTab;
            }
          },
        ));
  }
}
