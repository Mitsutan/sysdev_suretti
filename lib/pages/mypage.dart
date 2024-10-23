import 'package:flutter/material.dart';

// 表示状態を管理する列挙型
enum DisplayState {
  posts, // 自分の投稿
  favorites, // お気に入り
  bookmarks // ブックマーク
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DisplayState _currentState = DisplayState.posts; // 初期状態は自分の投稿

  void _switchDisplay(DisplayState newState) {
    setState(() {
      _currentState = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('マイページ'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () => _switchDisplay(DisplayState.posts),
                    style: OutlinedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      backgroundColor: _currentState == DisplayState.posts
                          ? Colors.grey[200]
                          : null,
                    ),
                    child: const Text('自分の投稿')),
                OutlinedButton(
                    onPressed: () => _switchDisplay(DisplayState.favorites),
                    style: OutlinedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      backgroundColor: _currentState == DisplayState.favorites
                          ? Colors.grey[200]
                          : null,
                    ),
                    child: const Text('お気に入り')),
                OutlinedButton(
                    onPressed: () => _switchDisplay(DisplayState.bookmarks),
                    style: OutlinedButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      backgroundColor: _currentState == DisplayState.bookmarks
                          ? Colors.grey[200]
                          : null,
                    ),
                    child: const Text('ブックマーク')),
              ],
            ),
            // 自分の投稿の表示
            Visibility(
              visible: _currentState == DisplayState.posts,
              child: _buildPostsList(),
            ),
            // お気に入りの表示
            Visibility(
              visible: _currentState == DisplayState.favorites,
              child: _buildFavoritesList(),
            ),
            // ブックマークの表示
            Visibility(
              visible: _currentState == DisplayState.bookmarks,
              child: _buildBookmarksList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return Column(
      children: [
        _buildUserCard(
            'すれちがいおにいさん', '2024/04/26', '@suretigai_man', 'こんにちは！この観光地おすすめです！'),
        _buildUserCard(
            'すれちがいおにいさん', '2024/04/27', '@suretigai_man', 'こんばんは！この観光地おすすめです！'),
      ],
    );
  }

  Widget _buildFavoritesList() {
    return Column(
      children: [
        _buildUserCard(
            'お気に入りユーザー1', '2024/02/06', '@favorite_user1', 'おはようございます！'),
      ],
    );
  }

  Widget _buildBookmarksList() {
    return Column(
      children: [
        _buildUserCard(
            'ブックマークユーザー1', '2024/10/13', '@bookmark_user1', 'こんばんは！'),
      ],
    );
  }

  Widget _buildUserCard(
      String username, String date, String userid, String message) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          date,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      userid,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      message,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.thumb_up_off_alt),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: _currentState == DisplayState.posts
                              ? const Icon(Icons.edit_document)
                              : const SizedBox.shrink(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
