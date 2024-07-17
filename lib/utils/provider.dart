import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserData());

class UserData extends ChangeNotifier {
  
  String _nickname = 'unknown';

  String get nickname => _nickname;

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }
}
