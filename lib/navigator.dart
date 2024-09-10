// タブメニューに表示するページ情報
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sysdev_suretti/pages/home.dart';
// import 'package:sysdev_suretti/pages/testhome.dart';

import 'pages/testpage1.dart';
import 'pages/testpage2.dart';

enum Pages {
  page1(
    title: 'ホーム',
    icon: Icons.home,
    page: HomeApp(),
  ),
  page2(
    title: 'page1',
    icon: Icons.home_repair_service_sharp,
    page: TestPage1(),
  ),
  page3(
    title: 'page2',
    icon: Icons.home_work_outlined,
    page: TestPage2(),
  );

  const Pages({
    required this.title,
    required this.icon,
    required this.page,
  });

  final String title;
  final IconData icon;
  final Widget page;
}

final _navigatorKeys = <Pages, GlobalKey<NavigatorState>>{
  Pages.page1: GlobalKey<NavigatorState>(),
  Pages.page2: GlobalKey<NavigatorState>(),
  Pages.page3: GlobalKey<NavigatorState>(),
};

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
                    icon: Icon(page.icon),
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
