import 'package:flutter/material.dart';

class MessageEdit extends StatelessWidget {
  final String category;
  final String recommend;
  final String address;
  final String message;
  const MessageEdit(this.category, this.recommend, this.address, this.message,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('投稿編集'),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                initialValue: category,
                decoration: InputDecoration(
                  labelText: 'カテゴリー',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                initialValue: recommend,
                cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                decoration: InputDecoration(
                  labelText: 'おすすめの場所',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                initialValue: address,
                decoration: InputDecoration(
                  labelText: '住所',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 5,
                cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                initialValue: message,
                decoration: InputDecoration(
                  labelText: 'メッセージ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'こちらの内容で編集しますか？',
                style: TextStyle(
                  color: Color(0xFFB3261E),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // ここの処理はまだ適当に書いてます
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //       builder: (context) => const MyHomePage(
                      //             title: '',
                      //           )),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Color(0xFF1A73E8), width: 1),
                      backgroundColor: const Color(0xFF1A73E8).withOpacity(0.8),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('はい'),
                  ),
                  const SizedBox(
                    width: 64,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Color(0xFF1A73E8), width: 1),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(100, 40),
                    ),
                    child: const Text('いいえ'),
                  )
                ],
              )
            ],
          )),
    );
  }
}
