import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/navigator.dart';
import 'package:sysdev_suretti/pages/login.dart';
import 'package:sysdev_suretti/utils/csb.dart';

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key, required this.email});

  final String title = 'メール確認';
  final String email;

  @override
  _ConfirmEmailPageState createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  // Future<int>? totalPriceFuture;

  void resendEmail() async {
    try {
      await Supabase.instance.client.auth
          .resend(email: widget.email, type: OtpType.signup);
    } catch (e) {
      log("exception: resend", error: e);
    }

    if (mounted) {
      Csb.showSnackBar(context, '確認メールを再送信しました', CsbType.nomal);
    }
  }

  late StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Navigation();
        }), (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "入力したメールアドレス(${widget.email})に確認メールを送信しました。\nメール内のリンクをクリックして登録を完了してください。"),
            ElevatedButton(
                onPressed: resendEmail, child: const Text("メールを再送信する")),
            TextButton(
                onPressed: () {
                  _authSubscription.cancel();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                child: const Text("ログインへ")),
          ],
        ),
      ),
    );
  }
}
