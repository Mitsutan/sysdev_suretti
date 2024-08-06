import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';

class PageNotifier extends ChangeNotifier {
  final Map<Pages, int> _pageCounts = {
    Pages.home: 0,
    Pages.search: 0,
    Pages.post: 0,
    Pages.notice: 0,
    Pages.profile: 0,
  };

  void updateCount(Pages page, int count) {
    _pageCounts[page] = count;
    log('updateCount: $page, $count');
    notifyListeners();
    log('updateCount: ${getCount(page)}');
  }

  int getCount(Pages page) => _pageCounts[page] ?? 0;
}
