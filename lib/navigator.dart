import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sysdev_suretti/stream_mock.dart';
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
    final secondsStream = useMemoized(() => SecondsStream(), []);

    useEffect(() {
      return () {
        secondsStream.dispose();
      };
    }, [secondsStream]);

    try {
      secondsStream.stream.listen((seconds) {
        pageNotifier.updateCount(Pages.notice, seconds);
      });
    } catch (e) {
      log("stream", error: e);
    }

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
                    icon: ValueListenableBuilder<int>(
                      valueListenable: pageNotifier.getCountNotifier(page),
                      builder: (context, count, child) {
                        // return Text(count.toString());
                        return Badge(
                          label: Text(count.toString()),
                          isLabelVisible: count == 0 ? false : true,
                          child: Icon(page.icon),
                        );
                      },
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
