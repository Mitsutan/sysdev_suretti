import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:convert';

//必要ない
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

//supabaseでCRUD操作を行うためのクラス
class SearchService {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> search(String query, String filter) async {
    // 検索処理
    var queryBuilder = supabase
        .from('messages')
        .select('')
        .ilike('recommended_place', '%$query%');

    // フィルターの適用
    if (filter == '観光地') {
      queryBuilder = queryBuilder.eq('category', '観光地');
    } else if (filter == '飲食店') {
      queryBuilder = queryBuilder.eq('category', '飲食店');
    } else if (filter == '宿泊地') {
      queryBuilder = queryBuilder.eq('category', '宿泊地');
    }
    // } else if (filter == '距離が近い') {
    //   queryBuilder = queryBuilder.order('distance', ascending: true);
    // } else if (filter == '距離が遠い') {
    //   queryBuilder = queryBuilder.order('distance', ascending: false);
    // } else if (filter == '新しい順') {
    //   queryBuilder = queryBuilder.order('created_at', ascending: false);
    // }

    final response = await queryBuilder.select().order('message_id', ascending: false);

    return response;
  }
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

  List<dynamic> _searchResults = []; // 検索結果を保持するリスト
  bool _isLoading = false; // データロード中の状態
  bool _noResultsFound = false; // 検索結果がない場合の状態

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
                  // フィルター選択後に検索を実行
                _performSearch(_searchController.text);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _noResultsFound = false;
    });

    final searchService = SearchService();
    try {
      final results = await searchService.search(query, _selectedFilter);
      setState(() {
        _searchResults = results;
        _noResultsFound = results.isEmpty;
      });
    } catch (e) {
      // エラー処理
      // print('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      hintText: '検索ワードを入力してください',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    // 検索処理を実行する
                    // onSubmitted: (String value) async {
                    //   final results =  SearchService (); // ← 検索処理を実行する
                    // },
                    onSubmitted: _performSearch,
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
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _noResultsFound
                        ? const Text(
                            '該当する場所が見つかりませんでした。\n再度検索してください。',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          )
                        : _searchResults.isEmpty
                          ? const Text(
                              '検索してください',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            )
                          : ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final result = _searchResults[index];
                                  return ListTile(
                                    title: Text(result['recommended_place']),
                                    subtitle: Text(result['address']),

                                  );
                                },
                              ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
