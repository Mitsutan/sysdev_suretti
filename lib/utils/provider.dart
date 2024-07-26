import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserData());

class UserData extends ChangeNotifier {
  
  String _nickname = 'unknown';

  String get nickname => _nickname;

  bool _isGotUserData = false;

  bool get isGotUserData => _isGotUserData;

  void updateNickname(String newNickname) {
    _nickname = newNickname;
    notifyListeners();
  }

  void updateIsGotUserData(bool isGotUserData) {
    _isGotUserData = isGotUserData;
  }
}
