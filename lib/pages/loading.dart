import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/navigator.dart';
import 'package:sysdev_suretti/pages/sign_up.dart';

// import 'package:sysdev_suretti/sign_up.dart';

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

    /// ログイン状態に応じて適切なページにリダイレクト
    final session = Supabase.instance.client.auth.currentSession;
    if (mounted) {
      if (session == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {

          return const SignupPage();
          // return const Navigation();

        }), (route) => false);
      } else {
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
