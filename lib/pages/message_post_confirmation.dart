import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/utils/provider.dart';

class MessagePostConfirmation extends ConsumerWidget {
  final String category;
  final String recommend;
  final String address;
  final String message;
  const MessagePostConfirmation(
      this.category, this.recommend, this.address, this.message,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    Future<void> postMessage() async {
      final supabase = Supabase.instance.client;

      try {
        final data = await supabase.from('messages').upsert({
          'category': category,
          'recommended_place': recommend,
          // 'location': address,
          'message_text': message,
          'user_id': userData.userData['user_id'],
        }).select();

        log('data: $data');
        final id = data.first['message_id'];
        // log('id: $id');

        await supabase.from('users').update({
          'message_id': id,
        }).eq('auth_id', supabase.auth.currentUser!.id);

        log('投稿しました');
      } catch (e) {
        log('エラーが発生しました: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 350,
            child: TextFormField(
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              initialValue: category,
              readOnly: true,
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
            width: 350,
            child: TextFormField(
              initialValue: recommend,
              readOnly: true,
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              decoration: InputDecoration(
                labelText: 'おすすめの場所',
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
            width: 350,
            child: TextFormField(
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              initialValue: address,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '住所',
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
            width: 350,
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              initialValue: message,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'メッセージ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'こちらの内容で投稿しますか？',
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
                  //       builder: (context) => MessagePostConfirmation(
                  //           category, recommend, address, message)),
                  // );
                  postMessage();
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF1A73E8), width: 1),
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
                  side: const BorderSide(color: Color(0xFF1A73E8), width: 1),
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
