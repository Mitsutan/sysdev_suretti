// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class VerifyCodeScreen extends StatefulWidget {
//   final String email; // メールアドレスを引き継ぐためのパラメータ

//   const VerifyCodeScreen({Key? key, required this.email}) : super(key: key);

//   @override
//   _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
// }

// class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
//   final _codeController = TextEditingController();
//   final supabase = Supabase.instance.client;

//   Future<void> _verifyCode() async {
//     final code = _codeController.text.trim();

//     if (code.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('認証コードを入力してください。')),
//       );
//       return;
//     }

//     try {
//       // Supabaseテーブルから認証コードを確認
//       final response = await supabase
//           .from('password_reset_requests')
//           .select()
//           .eq('email', widget.email)
//           .eq('code', code)
//           .eq('is_used', false)
//           .single();

//       if (response.error != null || response.data == null) {
//         throw Exception('認証コードが正しくありません。');
//       }

//       // コードを使用済みに更新
//       await supabase.from('password_reset_requests').update({
//         'is_used': true,
//       }).eq('id', response.data['id']).execute();

//       // 認証成功後、新しいパスワード設定画面に遷移
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ResetPasswordScreen(email: widget.email),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('エラーが発生しました: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('認証コード確認'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'メールアドレス ${widget.email} に送信された認証コードを入力してください。',
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _codeController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: '認証コード',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _verifyCode,
//               child: Text('確認'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ResetPasswordScreen extends StatelessWidget {
//   final String email;

//   const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('新しいパスワードの設定')),
//       body: Center(
//         child: Text('ここに新しいパスワード設定画面を実装します。'),
//       ),
//     );
//   }
// }
