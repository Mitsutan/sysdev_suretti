// import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'pages/testpage1.dart';
import 'pages/testpage2.dart';

// エントリーポイント
void main() {
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

// ルートウィジェット
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
