import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(SettingsApp());
}

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '設定',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _image;
  String _name = '名前';
  String _selectedNotificationFrequency = '1日or数日に一回';
  String _selectedLocationInfo = '公開';

  final _nameController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _editName() {
    setState(() {
      _name = _nameController.text;
    });
    Navigator.of(context).pop();
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('名前を編集'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: '名前を入力してください',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: _editName,
              child: Text('保存'),
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(String route) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceholderPage(route)),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ログアウト'),
          content: Text('ログアウトしました。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('設定'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 戻る処理をここに追加
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 設定アイコンの処理をここに追加
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // プロフィールアイコンと名前を横並びにする
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _image != null ? FileImage(_image!) : null,
                      child: _image == null ? Icon(Icons.camera_alt, size: 40) : null,
                    ),
                  ),
                  SizedBox(width: 16.0), // アイコンと名前の間の余白
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _showEditNameDialog,
                      ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('210****@********.ac.jp'),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () => _navigateTo('メールアドレス再設定'),
                child: RichText(
                  text: TextSpan(
                    text: 'メールアドレス再設定は',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'こちら',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text('**********xzy'),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: () => _navigateTo('パスワード再設定'),
                child: RichText(
                  text: TextSpan(
                    text: 'パスワード再設定は',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'こちら',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text('通知頻度'),
              DropdownButton<String>(
                value: _selectedNotificationFrequency,
                items: [
                  DropdownMenuItem(
                    child: Text('1日or数日に一回'),
                    value: '1日or数日に一回',
                  ),
                  DropdownMenuItem(
                    child: Text('ユーザーが指定した時間帯に'),
                    value: 'ユーザーが指定した時間帯に',
                  ),
                  DropdownMenuItem(
                    child: Text('何人か毎に'),
                    value: '何人か毎に',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedNotificationFrequency = value!;
                  });
                },
                hint: Text('選択してください'),
              ),
              SizedBox(height: 16.0),
              Text('位置情報'),
              DropdownButton<String>(
                value: _selectedLocationInfo,
                items: [
                  DropdownMenuItem(
                    child: Text('公開'),
                    value: '公開',
                  ),
                  DropdownMenuItem(
                    child: Text('非公開'),
                    value: '非公開',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedLocationInfo = value!;
                  });
                },
                hint: Text('選択してください'),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _navigateTo('投稿の編集'),
                child: RichText(
                  text: TextSpan(
                    text: '投稿の編集は',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'こちら',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _navigateTo('アカウントの切り替え'),
                child: RichText(
                  text: TextSpan(
                    text: 'アカウントの切り替えは',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'こちら',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _logout,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      'ログアウト',
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.0), // ログアウトと＋ボタンの間隔を開ける
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            SizedBox(width: 40.0), // 真ん中の余白
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 投稿ボタンの処理をここに追加
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('ここに$titleページの内容が表示されます'),
      ),
    );
  }
}
