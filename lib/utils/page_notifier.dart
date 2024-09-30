// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';

class PageNotifier extends ChangeNotifier {
  final Map<Pages, ValueNotifier<int>> _pageCounts = {
    Pages.home: ValueNotifier<int>(0),
    Pages.search: ValueNotifier<int>(0),
    Pages.post: ValueNotifier<int>(0),
    Pages.notice: ValueNotifier<int>(0),
    Pages.profile: ValueNotifier<int>(0),
  };

  void updateCount(Pages page, int count) {
    _pageCounts[page]?.value = count;
    // log('updateCount: $page, $count');
    notifyListeners();
    // log('updateCount: ${getCount(page)}');
  }

  // int getCount(Pages page) => _pageCounts[page] ?? 0;

  ValueNotifier<int> getCountNotifier(Pages page) {
    return _pageCounts[page]!;
  }
}
