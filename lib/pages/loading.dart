// ignore_for_file: unnecessary_nullable_for_final_variable_declarations

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/navigator.dart';
import 'package:sysdev_suretti/pages/sign_up.dart';
import 'package:sysdev_suretti/pages/new_password.dart';

// import 'package:sysdev_suretti/sign_up.dart';

/// ユーザーのログイン状態に応じて適切な画面へ遷移させる
/// 処理中はローディングインジケーターを表示
class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
  // widgetがmountするのを待つ
  await Future.delayed(Duration.zero);

  // メールリンクの処理
  final Uri currentUri = Uri.base;
  final AuthSessionUrlResponse? emailLink = await Supabase.instance.client.auth.getSessionFromUrl(currentUri);
  
  if (emailLink != null) {
    // メールリンクが存在する場合、パスワードリセットページに遷移
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const NewPasswordPage()),
      (route) => false,
    );
    return;
  }

    // ログイン状態に応じて適切なページにリダイレクト
  final session = Supabase.instance.client.auth.currentSession;
  if (mounted) {
    if (session == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const SignupPage();
        }), 
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          return const Navigation();
        }), 
        (route) => false,
      );
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
