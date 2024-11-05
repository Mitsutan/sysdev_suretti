import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserData());

class UserData extends ChangeNotifier {
  // String _nickname = 'unknown';

  // String get nickname => _nickname;

  dynamic _userData;

  dynamic get userData => _userData;

  bool _isGotUserData = false;

  bool get isGotUserData => _isGotUserData;

  // void updateNickname(String newNickname) {
  //   _nickname = newNickname;
  //   notifyListeners();
  // }

  /// usersテーブルからuser.auth_idをキーにしてユーザー情報を取得
  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final supabase = Supabase.instance.client;

    // try {
    await supabase
        .from('users')
        .select()
        .eq('auth_id', supabase.auth.currentUser!.id)
        .then((value) {
      log(value.toString());
      updateUserData(value.first);
      String userId = value.first['user_id'].toRadixString(16).padLeft(8, '0');
      // set to shared preference
      prefs.setInt('major', int.parse(userId.substring(0, 4), radix: 16));
      prefs.setInt('minor', int.parse(userId.substring(4, 8), radix: 16));

      updateIsGotUserData(true);
    }, onError: (error) {
      // debugPrint('getUserData error: $error');
      getUserData();
      return;
    });
    // log(user.toString());
    // userData.updateUserData(user.first);
    // String userId = user.first['user_id'].toRadixString(16).padLeft(8, '0');
    // beacon.major = int.parse(userId.substring(0, 4), radix: 16);
    // beacon.minor = int.parse(userId.substring(4, 8), radix: 16);
    // } catch (e) {
    //   log('getUserData error', error: e);
    //   rethrow;
    // return;
    // }
  }

  void updateUserData(dynamic newUserData) {
    _userData = newUserData;
    notifyListeners();
  }

  void updateIsGotUserData(bool isGotUserData) {
    _isGotUserData = isGotUserData;
  }
}
