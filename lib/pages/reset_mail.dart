import 'package:flutter/material.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text('メールアドレス変更'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 16),
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスを入力してください';
                }
                return null;
              },
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              decoration: InputDecoration(
                labelText: '新しいメールアドレス',
                hintText: '例)abc@example.com',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                ),
              ),
            ),
            const SizedBox(
              width: 16,
              height: 28,
            ),
            TextFormField(
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              decoration: InputDecoration(
                labelText: '新しいメールアドレス（確認）',
                hintText: '例)abc@example.com',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(
              width: 16,
              height: 28,
            ),
            TextFormField(
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              decoration: InputDecoration(
                labelText: 'パスワード',
                hintText: '8桁以上32桁以内',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'パスワードを入力してください';
                }
                return null;
              },
            ),
            const SizedBox(
              width: 16,
              height: 28,
            ),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('送信完了')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('メールアドレスを変更'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
