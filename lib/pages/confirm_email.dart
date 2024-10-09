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
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  Future<int>? totalPriceFuture;

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

  @override
  Widget build(BuildContext context) {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Navigation();
        }), (route) => false);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                "入力したメールアドレスに確認メールを送信しました。\nメール内のリンクをクリックして登録を完了してください。"),
                //スペースを追加しました。消してもらってもいいです。 by山下
                const SizedBox(height: 15),
            ElevatedButton(
                onPressed: resendEmail, child: const Text("メールを再送信する")),
            TextButton(
                onPressed: () {
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
