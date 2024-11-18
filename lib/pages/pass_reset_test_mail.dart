// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _emailController = TextEditingController();
//   final _supabase = Supabase.instance.client;

//   Future<void> sendResetLink() async {
//     final email = _emailController.text.trim();
    
//     try {
//       await _supabase.auth.resetPasswordForEmail(email);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('パスワードリセットリンクが送信されました。'))
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('エラーが発生しました: $error'))
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('パスワードリセット')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'メールアドレス'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendResetLink,
//               child: Text('送信'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
