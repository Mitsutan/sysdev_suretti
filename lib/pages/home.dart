import 'package:flutter/material.dart';

// void main() {
//   runApp(const HomeApp());
// }

// class HomeApp extends StatelessWidget {
//   const HomeApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ホーム',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ホーム'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 設定画面へ遷移する処理をここに追加
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: 2, // アイテムの数を設定
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(width: 8.0),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'すれちがいおにいさん',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '5分前に投稿',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // 追加の操作を表示する処理をここに追加
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  const Text('こんにちは！\nこれはサンプルのメッセージです。'),
                  const SizedBox(height: 8.0),
                  Image.network('https://via.placeholder.com/150'), // サンプル画像
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      // TextButton.icon(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.reply, color: Colors.blue),
                      //   label: Text('返信', style: TextStyle(color: Colors.blue)),
                      // ),
                      // Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up, color: Colors.grey),
                        label: const Text('いいね', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 16.0),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border, color: Colors.grey),
                        label: const Text('ブックマーク', style: TextStyle(color: Colors.grey)),
                      ),
                      const SizedBox(width: 16.0),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility, color: Colors.grey),
                        label: const Text('表示', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 6.0,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.home),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.search),
      //         onPressed: () {},
      //       ),
      //       const SizedBox(width: 40), // 中央のボタンのスペース
      //       IconButton(
      //         icon: const Icon(Icons.notifications),
      //         onPressed: () {},
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.person),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: '投稿',
      //   backgroundColor: Colors.blue,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
