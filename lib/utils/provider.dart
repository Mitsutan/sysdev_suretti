import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userDataProvider = ChangeNotifierProvider((ref) => UserData());

class UserData extends ChangeNotifier {
  dynamic _userData;

  dynamic get userData => _userData;

  UserData() {
    watchUserdata();
  }

  void watchUserdata() {
    final supabase = Supabase.instance.client;

    supabase
        .from('users')
        .stream(primaryKey: ['auth_id'])
        .eq('auth_id', supabase.auth.currentUser!.id)
        .listen((data) {
          updateUserData(data.first);
        });
  }

  void updateUserData(dynamic newUserData) {
    _userData = newUserData;
    notifyListeners();
  }
}
