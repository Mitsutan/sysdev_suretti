import 'package:flutter/material.dart';

void main() {
  runApp(PasswordResetApp());
}

class PasswordResetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'パスワード再設定',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PasswordResetPage(),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _errorMessage;

  void _validateAndSubmit() {
    setState(() {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        _errorMessage = "新しいパスワードが一致していません。";
      } else if (_newPasswordController.text.length < 8 ||
          _newPasswordController.text.length > 32) {
        _errorMessage = "パスワードは8文字以上、32文字以下で入力してください。";
      } else {
        _errorMessage = null;
        // ここで保存処理を追加
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("パスワードが更新されました")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('パスワード再設定'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '現在のパスワードを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '8桁以上32桁以内',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                '新しいパスワードを入力してください',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '8桁以上32桁以内',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'もう一度入力してください',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '8桁以上32桁以内',
                ),
              ),
              SizedBox(height: 16.0),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,//ここでなんか適当なエラーを表示する
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                SizedBox(height: 16.0),
              ],
              Center(
                child: ElevatedButton(//多分この下にパスワードを保存する処理を追加する
                  onPressed: _validateAndSubmit,
                  child: Text('登録する'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
