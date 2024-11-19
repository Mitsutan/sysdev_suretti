import 'package:flutter/material.dart';

class MessageDetail extends StatelessWidget {
  const MessageDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('メッセージ詳細'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // 設定画面へ遷移する処理をここに追加
              },
            ),
          ],
        ),
        body: const Column(
          // Paddingを削除
          children: [
            Padding(
              padding: EdgeInsets.all(16.0), // 投稿内容のPaddingはそのまま
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.yellow,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                'すれちがいお兄さんすれちがいお兄さん',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              flex: 2,
                              child: Text(
                                '@suretigai_man_very_long',
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '2024/10/31',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              // Paddingを削除し、Dividerを直接配置
              color: Colors.grey,
              height: 1,
            ),
          ],
        ));
  }
}
