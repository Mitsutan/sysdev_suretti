import 'package:flutter/material.dart';

void main() {
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ホーム',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('ホーム'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 設定画面へ遷移する処理をここに追加
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 2, // アイテムの数を設定
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 8.0),
                      Column(
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
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          // 追加の操作を表示する処理をここに追加
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text('こんにちは！\nこれはサンプルのメッセージです。'),
                  SizedBox(height: 8.0),
                  Image.network('https://via.placeholder.com/150'), // サンプル画像
                  SizedBox(height: 8.0),
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
                        icon: Icon(Icons.thumb_up, color: Colors.grey),
                        label: Text('いいね', style: TextStyle(color: Colors.grey)),
                      ),
                      SizedBox(width: 16.0),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border, color: Colors.grey),
                        label: Text('ブックマーク', style: TextStyle(color: Colors.grey)),
                      ),
                      SizedBox(width: 16.0),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.visibility, color: Colors.grey),
                        label: Text('表示', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
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
            SizedBox(width: 40), // 中央のボタンのスペース
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
        onPressed: () {},
        tooltip: '投稿',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
