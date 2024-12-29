import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/pages/new_password_screen.dart';

class AuthStateHandler {
  final BuildContext context;
  final supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  AuthStateHandler(this.context) {
    _initialize();
  }

  void _initialize() {
    try {
      _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        
        // デバッグ用
        print('Auth state changed: $event');
        
        switch (event) {
          case AuthChangeEvent.passwordRecovery:
            _handlePasswordRecovery();
            break;
          case AuthChangeEvent.signedOut:
            // ログアウト時の処理
            break;
          default:
            break;
        }
      }, onError: (error) {
        print('Auth state error: $error');
      });
    } catch (e) {
      print('Error initializing auth state handler: $e');
    }
  }

  void _handlePasswordRecovery() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NewPasswordScreen(),
          ),
        );
      });
    } catch (e) {
      print('Error handling password recovery: $e');
    }
  }

  void dispose() {
    _authSubscription.cancel();
  }
}