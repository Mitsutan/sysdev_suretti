import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/home.dart';
import 'package:sysdev_suretti/pages/message_settings.dart';
import 'package:sysdev_suretti/pages/search_screen.dart';
import 'package:sysdev_suretti/pages/setting.dart';
// import 'package:sysdev_suretti/pages/testhome.dart';
// import 'package:sysdev_suretti/pages/testpage1.dart';
import 'package:sysdev_suretti/pages/notice.dart';

/// ナビゲーションバーに表示する画面
enum Pages {
  home(
    title: 'ホーム',
    icon: Icons.home,
    page: HomePage(),
  ),
  search(
    title: '検索',
    icon: Icons.search,
    page: SearchPage(),
  ),
  post(
    title: '投稿',
    icon: Icons.add_comment,
    page: MessageSettingsPage(),
  ),
  notice(
    title: '通知',
    icon: Icons.notifications,
    page: NotificationPage(),
  ),
  profile(
    title: 'アカウント',
    icon: Icons.account_circle,
    page: SettingsPage(),
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
