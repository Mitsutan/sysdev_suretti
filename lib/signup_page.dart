// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// final Logger _logger = Logger('SignUpPageLogger');
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   Future<void> _signUp() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       final email = _emailController.text;
//       final password = _passwordController.text;
//
//       try {
//         final response = await Supabase.instance.client.auth.signUp(
//           email: email,
//           password: password,
//         );
//
//         if (response.session != null && response.user != null) {
//           _logger.info('Sign up successful');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Sign up successful')),
//             );
//           }
//         } else {
//           _logger.severe('Sign up failed');
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Sign up failed')),
//             );
//           }
//         }
//       } on AuthException catch (e) {
//         _logger.severe('Sign up failed: ${e.message}');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Sign up failed: ${e.message}')),
//           );
//         }
//       } catch (e) {
//         _logger.severe('Sign up failed', e);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Sign up failed')),
//           );
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _signUp,
//                 child: const Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
