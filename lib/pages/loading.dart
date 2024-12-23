import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/navigator.dart';
import 'package:sysdev_suretti/pages/sign_up.dart';

// import 'package:sysdev_suretti/sign_up.dart';

/// ユーザーのログイン状態に応じて適切な画面へ遷移させる
/// 処理中はローディングインジケーターを表示
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  /// 利便性のためSupabaseのクライアントインスタンスを代入
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  /// FCMトークンを保存
  Future<void> _setFcmToken(String token) async {
    if (supabase.auth.currentUser == null) {
      log('ログインしていないためFCMトークンを保存できません', name: 'LoginPage');
      return;
    }
    await supabase.from('users').update({
      'fcm_token': token,
    }).eq('auth_id', supabase.auth.currentUser!.id);
  }

  Future<void> _redirect() async {
    // widgetがmountするのを待つ
    await Future.delayed(Duration.zero);

    /// ログイン状態に応じて適切なページにリダイレクト
    final session = supabase.auth.currentSession;
    if (mounted) {
      if (session == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const SignupPage();
          // return const Navigation();
        }), (route) => false);
      } else {
        // 通知の許可を求める
        await FirebaseMessaging.instance.requestPermission();

        // FCMトークンの取得と保存
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          await _setFcmToken(fcmToken);
        }

        // FCMトークンのリフレッシュ時の処理
        FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
          log('FCMトークンのリフレッシュ: $token', name: 'LoginPage');
          await _setFcmToken(token);
        });

        if (!mounted) {
          return;
        }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Navigation();
        }), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
