import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sysdev_suretti/utils/enum_pages.dart';

final noticesProvider = ChangeNotifierProvider((ref) => NoticesProvider());

class NoticesProvider extends ChangeNotifier {
  final Map<Pages, int> _pageNoticeCounts = {
    Pages.home: 0,
    Pages.search: 0,
    Pages.post: 0,
    Pages.notice: 0,
    Pages.profile: 0,
  };

  Map<Pages, int> get pageNoticeCounts => _pageNoticeCounts;

  void updateNoticeCount(Pages page, int count) {
    _pageNoticeCounts[page] = count;
    notifyListeners();
  }

  int getNoticeCount(Pages page) => _pageNoticeCounts[page] ?? 0;
}
