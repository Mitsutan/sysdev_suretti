import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Results',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchResultsScreen(),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults = [
    {
      'name': '志摩スペイン村',
      'address': '三重県志摩市磯部町坂崎',
      'distance': '3.7 km'
    },
    {
      'name': '伊勢志摩温泉 ひまわりの湯',
      'address': '三重県志摩市磯部町坂崎',
      'distance': '2.9 km'
    },
    {
      'name': 'ハビエル城博物館',
      'address': '三重県志摩市阿児町鵜方',
      'distance': '5.6 km'
    },
    {
      'name': '伊勢志摩エバーグレイズ',
      'address': '三重県志摩市磯部町川',
      'distance': '1.5 km'
    },
    {
      'name': '大矢浜海水浴場',
      'address': '三重県志摩市阿児町鵜方',
      'distance': '5.9 km'
    },
  ];

  SearchResultsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('検索結果'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // 戻るボタンの処理
        //   },
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 設定ボタンの処理
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 検索バーとフィルターボタン
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '検索したいキーワードを入力してください',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
              ],
            ),
          ),
          // 検索結果リスト
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      color: Colors.grey.shade300, // 仮の画像スペース
                      child: const Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                    title: Text(searchResults[index]['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(searchResults[index]['address']),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16.0, color: Colors.red),
                            const SizedBox(width: 4.0),
                            Text('距離: ${searchResults[index]['distance']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // 詳細ページに遷移する処理を追加
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // ホーム画面に戻る処理を追加
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 現在の検索画面
              },
            ),
            const SizedBox(width: 40), // 中央のボタンのスペース
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // 通知画面へ遷移する処理を追加
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // マイページへ遷移する処理を追加
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 投稿ページへ遷移する処理を追加
        },
        tooltip: '投稿',
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // フィルター機能のダイアログ
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('フィルター'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('観光地'),
                value: true,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('飲食店'),
                value: false,
                onChanged: (value) {},
              ),
              CheckboxListTile(
                title: const Text('宿泊地'),
                value: false,
                onChanged: (value) {},
              ),
              const Divider(),
              ListTile(
                title: const Text('距離が近い'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('距離が遠い'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('新しい順'),
                onTap: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
