<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:sysdev_suretti/pages/login.dart';
=======
>>>>>>> Stashed changes

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:sysdev_suretti/pages/login.dart';
// import 'dart:developer';

// class PasswordForgetPage extends StatefulWidget {
//   const PasswordForgetPage({super.key});

<<<<<<< Updated upstream
class _PasswordForgetPageState extends State<PasswordForgetPage> {
  final _emailController = TextEditingController();
=======
//   @override
//   _PasswordForgetPageState createState() => _PasswordForgetPageState();
// }
>>>>>>> Stashed changes

// class _PasswordForgetPageState extends State<PasswordForgetPage> {
//   final _emailController = TextEditingController();
//   final _supabase = Supabase.instance.client;

<<<<<<< Updated upstream
  void _validateAndSubmit() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _errorMessage = "メールアドレスを入力してください。";
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailController.text)) {
        _errorMessage = "メールアドレスの形式が正しくありません。";
      } else {
        _errorMessage = null;
        // ここで保存処理を追加
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("認証メールを送信しました。")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 左右のパディングを考慮した幅を計算
    final contentWidth = screenWidth - 32.0; // 左右16pxずつのパディング
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('パスワード再設定'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'メールアドレスを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'メールアドレスを入力',
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ご登録されたメールアドレスに認証メールを送信します。"),
                ],
              ),
              const SizedBox(height: 32.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!, //ここでなんか適当なエラーを表示する
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 16.0),
              ],
              SizedBox(
                width: contentWidth,
                height: 48.0,
                child: ElevatedButton(
                  //多分この下にパスワードを保存する処理を追加する
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 100.0),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text('次へ'),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  },
                  child: const Text('ログインへ戻る')),
            ],
          ),
        ),
      ),
    );
  }
}
=======
//   String? _errorMessage;

//   Future<void> sendResetLink() async {
//     log('パスワードリセットリンク送信処理開始', name: 'PasswordForgetPage');
//     final email = _emailController.text.trim();
//     ////auth.resetPasswordForEmail(email)でパスワードリセットリンクを送信
//     try {
//       // await _supabase.auth.resetPasswordForEmail(email);
//       await Supabase.instance.client.auth.resetPasswordForEmail(email);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('パスワードリセットリンクが送信されました。'))
//       );
//     //メール送信した後の画面遷移
//       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//         return LoginPage();
//       }));

//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('エラーが発生しました: $error'))
//       );
//       log("エラーが発生しました: $error", name: 'PasswordForgetPage');
//     }
//   }

//   void _validateAndSubmit() {
//     setState(() {
//       if (_emailController.text.isEmpty) {
//         _errorMessage = "メールアドレスを入力してください。";
//       } else if (!RegExp(
//               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//           .hasMatch(_emailController.text)) {
//         _errorMessage = "メールアドレスの形式が正しくありません。";
//       } else {
//         _errorMessage = null;
//         sendResetLink();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final contentWidth = screenWidth - 32.0; // 左右16pxずつのパディング
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('パスワード再設定'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'メールアドレスを入力してください',
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 32.0),
//               TextField(
//                 controller: _emailController,
//                 obscureText: false,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'メールアドレスを入力',
//                 ),
//               ),
//               const Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("ご登録されたメールアドレスに認証メールを送信します。"),
//                 ],
//               ),
//               const SizedBox(height: 32.0),
//               if (_errorMessage != null) ...[
//                 Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red, fontSize: 14),
//                 ),
//                 const SizedBox(height: 16.0),
//               ],
//               SizedBox(
//                 width: contentWidth,
//                 height: 48.0,
//                 child: ElevatedButton(
//                   onPressed: _validateAndSubmit,
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 100.0),
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   child: const Text('送信'),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16.0,
//               ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context)
//                         .push(MaterialPageRoute(builder: (context) {
//                       return const LoginPage();
//                     }));
//                   },
//                   child: const Text('ログインへ戻る')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
>>>>>>> Stashed changes
