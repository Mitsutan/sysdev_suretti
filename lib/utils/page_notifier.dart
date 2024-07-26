import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';

class PageNotifier extends ChangeNotifier {
  final Map<Pages, int> _pageCounts = {
    Pages.page1: 0,
    Pages.page2: 0,
    Pages.page3: 0,
    Pages.page4: 0,
    Pages.page5: 0,
  };

  void updateCount(Pages page, int count) {
    _pageCounts[page] = count;
    log('updateCount: $page, $count');
    notifyListeners();
    log('updateCount: ${getCount(page)}');
  }

  int getCount(Pages page) => _pageCounts[page] ?? 0;
}
