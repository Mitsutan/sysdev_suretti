import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/message_settings.dart';
import 'package:sysdev_suretti/pages/search_screen.dart';
import 'package:sysdev_suretti/pages/testhome.dart';
// import 'package:sysdev_suretti/pages/testpage1.dart';
import 'package:sysdev_suretti/pages/testpage2.dart';

enum Pages {
  home(
    title: 'ホーム',
    icon: Icons.home,
    page: Testhome(),
  ),
  search(
    title: '検索',
    icon: Icons.search,
    page: SearchApp(),
  ),
  post(
    title: '投稿',
    icon: Icons.add_comment,
    page: MessageSettingsPage(),
  ),
  notice(
    title: '通知',
    icon: Icons.notifications,
    page: TestPage2(),
  ),
  profile(
    title: 'アカウント',
    icon: Icons.account_circle,
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
