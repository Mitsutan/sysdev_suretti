// タブメニューに表示するページ情報
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';
import 'package:sysdev_suretti/utils/page_notifier.dart';




final _navigatorKeys = <Pages, GlobalKey<NavigatorState>>{
  Pages.home: GlobalKey<NavigatorState>(),
  Pages.search: GlobalKey<NavigatorState>(),
  Pages.post: GlobalKey<NavigatorState>(),
  Pages.notice: GlobalKey<NavigatorState>(),
  Pages.profile: GlobalKey<NavigatorState>(),
};

// ナビゲーターウィジェット
class Navigation extends HookWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTab = useState(Pages.home);
    final pageNotifier = useMemoized(() => PageNotifier(), []);

    // pageNotifier.updateCount(Pages.page4, pageNotifier.getCount(Pages.page4) + 1);

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
                    icon: Badge(
                      label: Text('${pageNotifier.getCount(page)}'),
                      isLabelVisible: pageNotifier.getCount(page) == 0 ? false : true,
                      child: Icon(page.icon),
                    ),
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
