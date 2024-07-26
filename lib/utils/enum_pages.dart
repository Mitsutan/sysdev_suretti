import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/testhome.dart';
import 'package:sysdev_suretti/pages/testpage1.dart';
import 'package:sysdev_suretti/pages/testpage2.dart';

enum Pages {
  page1(
    title: 'ホーム',
    icon: Icons.home,
    page: Testhome(),
  ),
  page2(
    title: '検索',
    icon: Icons.search,
    page: TestPage1(),
  ),
  page3(
    title: '投稿',
    icon: Icons.add_comment,
    page: TestPage2(),
  ),
  page4(
    title: '通知',
    icon: Icons.notifications,
    page: TestPage2(),
  ),
  page5(
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
