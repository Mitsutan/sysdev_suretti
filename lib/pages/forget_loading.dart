
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uni_links/uni_links.dart';

// class ForgetLoading extends StatefulWidget {
//   const ForgetLoading({Key? key}) : super(key: key);

//   @override
//   _ForgetLoadingState createState() => _ForgetLoadingState();
// }

// class _ForgetLoadingState extends State<ForgetLoading> {
//   Uri? _deepLinkUri;

//   @override
//   void initState() {
//     super.initState();
//     _initDeepLink();
//   }

//   // Deep Linkの初期化処理
//   Future<void> _initDeepLink() async {
//     // アプリがバックグラウンドで起動した場合や、リンクが最初にクリックされたときの処理
//     try {
//       final initialLink = await getInitialLink();
//       log('Initial deep link: $initialLink'); // ログを確認
//       if (initialLink != null) {
//         setState(() {
//           _deepLinkUri = Uri.parse(initialLink);
//         });
//       }

//       // アプリが起動中にリンクがクリックされた場合
//       linkStream.listen((String? link) {
//         log('Stream deep link: $link');
//         if (link != null) {
//           setState(() {
//             _deepLinkUri = Uri.parse(link);
//           });
//         }
//       });
//     } catch (e) {
//       log('Failed to get deep link: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Deep LinkのURLが取得できていれば新しいパスワード画面へ遷移
//     if (_deepLinkUri != null) {
//       log("Deep Link: ${_deepLinkUri.toString()}");
//       Future.delayed(Duration.zero, () {
//         Navigator.pushReplacementNamed(context, '/new_password');
//       });
//     }

//     // ローディング中のUI
//     return Scaffold(
//       appBar: AppBar(title: const Text('Processing Link')),
//       body: const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
