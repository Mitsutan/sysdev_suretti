import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserData());

class UserData extends ChangeNotifier {
  dynamic _userData;

  dynamic get userData => _userData;

  late final SharedPreferences _prefs;

  UserData() {
    _initPrefs();
    watchUserdata();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void watchUserdata() {
    final supabase = Supabase.instance.client;

    supabase
        .from('users')
        .stream(primaryKey: ['auth_id'])
        .eq('auth_id', supabase.auth.currentUser!.id)
        .listen((data) {
          if (_prefs.getInt('major') == null ||
              _prefs.getInt('minor') == null) {
            String userId = int.parse(data.first['user_id'].toString())
                .toRadixString(16)
                .padLeft(8, '0');
            _prefs.setInt(
                'major', int.parse(userId.substring(0, 4), radix: 16));
            _prefs.setInt(
                'minor', int.parse(userId.substring(4, 8), radix: 16));
          }
          updateUserData(data.first);
        });
  }

  void updateUserData(dynamic newUserData) {
    _userData = newUserData;
    notifyListeners();
  }
}
