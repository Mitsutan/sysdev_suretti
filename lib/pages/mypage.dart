import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/utils/db_provider.dart';
import 'package:sysdev_suretti/utils/display_time.dart';
import 'package:sysdev_suretti/utils/post_card.dart';

final supabase = Supabase.instance.client;

late final SharedPreferences _prefs;
int userId = 0;

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '自分の投稿'),
                Tab(text: 'お気に入り'),
                Tab(text: 'ブックマーク'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _PostsList(),
                  _FavoritesList(),
                  _BookmarksList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (userId == 0) {
      return const Text('ユーザーIDが取得できませんでした');
    }

    return Scaffold(
        body: StreamBuilder(
      stream: supabase.from('messages').stream(
          primaryKey: ['message_id']).order('post_timestamp', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('snapshot error:', error: snapshot.error);
          return const Text('エラーが発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        final posts = snapshot.data; // as List;
        if (posts != null) {
          posts.removeWhere((post) => post['user_id'] != userId);
        }
        if (posts == null ||
            snapshot.connectionState == ConnectionState.done && posts.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text('まだ投稿がありません'),
          );
        }
        // log('posts: $posts');
        return FutureBuilder(
            future: supabase.from('users').select().eq('user_id', userId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log('snapshot error:', error: snapshot.error);
                return const Text('エラーが発生しました');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              final user = snapshot.data!.first;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return PostCard(
                    selfUserId: userId,
                    iconpath: user['icon'].toString(),
                    username: user['nickname'].toString(),
                    date: formatDate(post['post_timestamp'].toString()),
                    userid: user['user_id'],
                    message: post['message_text'].toString(),
                    messageId: post['message_id'],
                    recommend: post['recommended_place'].toString(),
                    address: post['address'].toString(),
                    location: post['location'],
                    isEditable: true,
                  );
                },
              );
            });
      },
    ));
  }
}

class _FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: supabase
          .from('favorites')
          .select(
              '*, messages!favorites_message_id_fkey(*, users!messages_user_id_fkey(*))')
          .eq('user_id', userId)
          .order('registration_date', ascending: false)
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('snapshot error:', error: snapshot.error);
          return const Text('エラーが発生しました');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
        final favorites = snapshot.data; // as List;
        if (favorites == null ||
            snapshot.connectionState == ConnectionState.done &&
                favorites.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text('いいねした投稿がありません'),
          );
        }
        // log('favorites: $favorites');
        return ListView.builder(
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
        );
      },
    ));
  }
}

class _BookmarksList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    final database = db.database;
    return Scaffold(
        body: StreamBuilder(
            stream: database.watchBookmarks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                log('snapshot error:', error: snapshot.error);
                return const Text('エラーが発生しました');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
              final bookmarks = snapshot.data; // as List;
              if (bookmarks == null ||
                  snapshot.connectionState == ConnectionState.done &&
                      bookmarks.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: const Text('ブックマークした投稿がありません'),
                );
              }
              // log('bookmarks: $bookmarks');
              return ListView.builder(
                shrinkWrap: true,
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  log('bookmark: ${bookmark.messageId}');
                  return FutureBuilder(
                    future: supabase
                        .from('messages')
                        .select(
                            '*, users!messages_user_id_fkey(*, icon, nickname)')
                        .eq('message_id', bookmark.messageId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        log('snapshot error:', error: snapshot.error);
                        return const Text('エラーが発生しました');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      final bm = snapshot.data!.firstOrNull;
                      if (bm == null) {
                        database.deleteBookmark(bookmark.messageId);
                        return const Text('投稿が見つかりません');
                      }
                      log('bookmark: $bm');
                      return PostCard(
                        selfUserId: userId,
                        iconpath: bm['users']['icon'].toString(),
                        username: bm['users']['nickname'].toString(),
                        date: diffTime(DateTime.now(),
                            DateTime.parse(bm['post_timestamp'].toString())),
                        userid: bm['users']['user_id'],
                        message: bm['message_text'].toString(),
                        messageId: bm['message_id'],
                        recommend: bm['recommended_place'].toString(),
                        address: bm['address'].toString(),
                        location: bm['location'],
                        isEditable: false,
                      );
                    },
                  );
                },
              );
            }));
  }
}
