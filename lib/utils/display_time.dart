import 'package:intl/intl.dart';

String diffTime(DateTime base, DateTime target) {
  final diffInSeconds = base.difference(target).inSeconds;
  if (diffInSeconds < 60) {
    return '$diffInSeconds秒前';
  }

  final diffInMinutes = base.difference(target).inMinutes;
  if (diffInMinutes < 60) {
    return '$diffInMinutes分前';
  }

  final diffInHours = base.difference(target).inHours;
  if (diffInHours < 24) {
    return '$diffInHours時間前';
  }

  final diffInDays = base.difference(target).inDays;
  if (diffInDays < 7) {
    return '$diffInDays日前';
  }

  final diffInWeeks = (diffInDays / 7).floor();
  if (diffInWeeks < 4) {
    return '$diffInWeeks週間前';
  }

  final diffInMonths = (diffInDays / 30).floor();
  if (diffInWeeks >= 4 && diffInMonths < 2) {
    return '1ヶ月前';
  } else if (diffInMonths < 12) {
    return '$diffInMonthsヶ月前';
  }

  final diffInYears = (diffInDays / 365).floor();
  return '$diffInYears年前';
}

String formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(dateStr);
  DateFormat formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
  return formatter.format(dateTime);
}
