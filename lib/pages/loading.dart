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
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // widgetがmountするのを待つ
    await Future.delayed(Duration.zero);

<<<<<<< Updated upstream
    /// ログイン状態に応じて適切なページにリダイレクト
=======
      /// ログイン状態に応じて適切なページにリダイレクト
>>>>>>> Stashed changes
    final session = Supabase.instance.client.auth.currentSession;
    if (mounted) {
      if (session == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
<<<<<<< Updated upstream

          return const SignupPage();
          // return const Navigation();

=======
          return const SignupPage();
          // return const Navigation();
>>>>>>> Stashed changes
        }), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return const Navigation();
<<<<<<< Updated upstream
        }), (route) => false);
      }
    }
  }
=======
                }), (route) => false);
      }
    }
  }


>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
