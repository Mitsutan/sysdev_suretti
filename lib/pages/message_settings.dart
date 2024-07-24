import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sysdev_suretti/pages/message_post_confirmation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Settings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MessageSettings(),
    );
  }
}

class MessageSettings extends StatefulWidget {
  const MessageSettings({super.key});

  @override
  State<MessageSettings> createState() => _MessageSettings();
}

class _MessageSettings extends State<MessageSettings> {
  String category = '宿泊地';
  String recommend = '';
  String address = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: DropdownButtonFormField<String>(
                  hint: const Text('カテゴリーを選択してください'),
                  itemHeight: 64,
                  value: category,
                  onChanged: (String? newValue) {
                    setState(() {
                      category = newValue!;
                    });
                  },
                  items: <String>['宿泊地', '観光地', '飲食店']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'カテゴリー',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  onChanged: (value) {
                    setState(() {
                      recommend = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'おすすめの場所',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '住所',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'メッセージ',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  // フォームが送信されたときの処理を記述
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => MessagePostConfirmation(
                            category, recommend, address, message)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1A73E8)),
                  minimumSize: const Size(100, 40),
                ),
                child: const Text('送信'),
              ),
            ],
          ),
        ));
  }
}
