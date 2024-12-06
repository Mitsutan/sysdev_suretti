import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/utils/display_time.dart';
import 'package:sysdev_suretti/utils/post_card.dart';

// 表示状態を管理する列挙型
enum DisplayState {
  posts, // 自分の投稿
  favorites, // お気に入り
  bookmarks // ブックマーク
}

final supabase = Supabase.instance.client;

late final SharedPreferences _prefs;
int userId = 0;

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
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      log("init fail", error: e);
    }

    setState(() {
      final major = _prefs.getInt('major').toString();
      final minor = _prefs.getInt('minor').toString();

      userId = int.parse(major + minor);
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
    if (userId == 0) {
      return const Text('ユーザーIDが取得できませんでした');
    }

    return StreamBuilder(
      stream: supabase
          .from('messages')
          .select('*, users!messages_user_id_fkey(*)')
          .eq('user_id', userId)
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('snapshot error:', error: snapshot.error);
          return const Text('エラーが発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final posts = snapshot.data; // as List;
        if (posts == null) {
          return const Text('データがありません');
        }
        // log('posts: $posts');
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                selfUserId: userId,
                iconpath: post['users']['icon'].toString(),
                username: post['users']['nickname'].toString(),
                date: formatDate(post['post_timestamp'].toString()),
                userid: post['users']['user_id'],
                message: post['message_text'].toString(),
                messageId: post['message_id'],
                recommend: post['recommended_place'].toString(),
                address: post['address'].toString(),
                location: post['location'],
                isEditable: true,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return StreamBuilder(
      stream: supabase
          .from('favorites')
          .select(
              '*, messages!favorites_message_id_fkey(*, users!messages_user_id_fkey(*))')
          .eq('user_id', userId)
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('snapshot error:', error: snapshot.error);
          return const Text('エラーが発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final favorites = snapshot.data; // as List;
        if (favorites == null) {
          return const Text('データがありません');
        }
        // log('favorites: $favorites');
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              log('favorite: $favorite');
              return PostCard(
                selfUserId: userId,
                iconpath: favorite['messages']['users']['icon'].toString(),
                username: favorite['messages']['users']['nickname'].toString(),
                date: diffTime(
                    DateTime.now(),
                    DateTime.parse(
                        favorite['messages']['post_timestamp'].toString())),
                userid: favorite['messages']['users']['user_id'],
                message: favorite['messages']['message_text'].toString(),
                messageId: favorite['message_id'],
                recommend: favorite['messages']['recommended_place'].toString(),
                address: favorite['messages']['address'].toString(),
                location: favorite['messages']['location'],
                isEditable: false,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookmarksList() {
    return const Column(
      children: [
        // _buildUserCard("", 'ブックマークユーザー1', '2024/10/13', '0', 'こんばんは！', 0),
        // PostCard(
        //     selfUserId: userId,
        //     iconpath: "",
        //     username: 'ブックマークユーザー1',
        //     date: '2024/10/13',
        //     userid: 0,
        //     message: 'こんばんは！',
        //     messageId: 0,
        //     recommend: 'おすすめの場所',
        //     address: '住所',
        //     location: 'POINT(0 0)',
        //     isEditable: false),
      ],
    );
  }
}
