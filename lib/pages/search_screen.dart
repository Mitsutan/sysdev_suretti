import 'package:flutter/material.dart';

// void main() {
//   runApp(SearchApp());
// }

class SearchApp extends StatelessWidget {
  const SearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      title: '検索画面',
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "フィルター";
  final List<String> _filters = [
    '観光地',
    '飲食店',
    '宿泊地',
    '距離が近い',
    '距離が遠い',
    '新しい順'
  ];

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("フィルターを選択"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filters.map((filter) {
              return ListTile(
                title: Text(filter),
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('検索'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // 戻る処理（実際にはNavigator.pop()などを使用）
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 設定画面を開く処理
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: '検索したいキーワードを入力してください',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '選択されたフィルター: $_selectedFilter',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text(
                  '検索してください',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
