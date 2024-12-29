// import 'package:flutter/material.dart';
// import 'package:sysdev_suretti/pages/login.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';


// class NewPasswordPage extends StatefulWidget {
//   const NewPasswordPage({super.key, this.accessToken});
//   final String? accessToken; // パスワードリセットに使用されるトークン

//   @override
//   _NewPasswordPageState createState() => _NewPasswordPageState();
// }

// class _NewPasswordPageState extends State<NewPasswordPage> {
//   final _currentPasswordController = TextEditingController();
//   final _newPasswordController = TextEditingController();

<<<<<<< Updated upstream
  void _validateAndSubmit() {
    setState(() {
      if (_currentPasswordController.text.isEmpty ||
          _newPasswordController.text.isEmpty) {
        _errorMessage = "新しいパスワードを入力してください。";
      } else if (_newPasswordController.text.length < 8 ||
          _newPasswordController.text.length > 32) {
        _errorMessage = "パスワードは8文字以上、32文字以下で入力してください。";
      } else if (_currentPasswordController.text !=
          _newPasswordController.text) {
        _errorMessage = "パスワードが一致しません。";
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
        title: const Text('新規パスワード入力'),
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
                '新しいパスワードを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32.0),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '新しいパスワードを入力',
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '新しいパスワードを再入力',
                ),
              ),
              const SizedBox(height: 16.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!, //ここでなんか適当なエラーを表示する
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 32.0),
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
                  child: const Text('変更'),
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

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   handleDynamicLinks();
//   // }

//   // // Firebase Dynamic Linksの処理を追加
//   // void handleDynamicLinks() {
//   //   FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
//   //     final Uri? deepLink = data.link;
//   //     if (deepLink != null && deepLink.path == '/reset-password') {
//   //       Navigator.pushNamed(context, '/reset-password');
//   //     }
//   //   }).onError((error) {
//   //     print('Error handling deep link: $error');
//   //   });
//   // }

//   // パスワードリセットを実行する関数
//   Future<void> _resetPassword() async {
//   final newPassword = _newPasswordController.text;
//   final accessToken = widget.accessToken;

//   if (accessToken == null) {
//     setState(() {
//       _errorMessage = "無効なリセットリンクです。";
//     });
//     return;
//   }

//     try {
//     // アクセストークンを使用してセッションを更新
//     await Supabase.instance.client.auth.verifyOTP(
//       token: accessToken,
//       type: OtpType.recovery,
//     );

//     // パスワードの更新
//     final response = await Supabase.instance.client.auth.updateUser(
//       UserAttributes(password: newPassword),
//     );

//     if (response.user == null) {
//       setState(() {
//         _errorMessage = "パスワードのリセットに失敗しました。";
//       });
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("パスワードがリセットされました。")),
//         );
//         Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => const LoginPage()),
//           (route) => false,
//         );
//       }
//     }
//     } catch (e) {
//       setState(() {
//         _errorMessage = "エラーが発生しました: $e";
//       });
//     }
//   }

//   void _validateAndSubmit() {
//     setState(() {
//       if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
//         _errorMessage = "新しいパスワードを入力してください。";
//       } else if (_newPasswordController.text.length < 8 || _newPasswordController.text.length > 32) {
//         _errorMessage = "パスワードは8文字以上、32文字以下で入力してください。";
//       } else if (_currentPasswordController.text != _newPasswordController.text) {
//         _errorMessage = "パスワードが一致しません。";
//       } else {
//         _errorMessage = null;
//         _resetPassword(); // パスワードリセット処理を呼び出す
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     // 左右のパディングを考慮した幅を計算
//     final contentWidth = screenWidth - 32.0; // 左右16pxずつのパディング
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('新規パスワード入力'),
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
//                 '新しいパスワードを入力してください',
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 32.0),
//               TextField(
//                 controller: _currentPasswordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: '新しいパスワードを入力',
//                 ),
//               ),
//               const SizedBox(height: 8.0),
//               TextField(
//                 controller: _newPasswordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: '新しいパスワードを再入力',
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               if (_errorMessage != null) ...[
//                 Text(
//                   _errorMessage!, // エラーメッセージ表示
//                   style: const TextStyle(color: Colors.red, fontSize: 14),
//                 ),
//                 const SizedBox(height: 32.0),
//               ],
//               SizedBox(
//                 width: contentWidth,
//                 height: 48.0,
//                 child: ElevatedButton(
//                   onPressed: () => _validateAndSubmit(), // バリデーションと送信
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(horizontal: 100.0),
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                   ),
//                   child: const Text('変更'),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16.0,
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//                     return const LoginPage(); // ログイン画面に戻る
//                   }));
//                 },
//                 child: const Text('ログインへ戻る'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
>>>>>>> Stashed changes
