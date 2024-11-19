import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sysdev_suretti/utils/display_time.dart';
import 'package:sysdev_suretti/utils/favorite.dart';

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
              return _buildUserCard(
                post['users']['icon'].toString(),
                post['users']['nickname'].toString(),
                formatDate(post['post_timestamp'].toString()),
                post['users']['user_id'].toString(),
                post['message_text'].toString(),
                post['message_id'],
              );
              // return UserCard(
              //   iconpath: post['users']['icon'].toString(),
              //   username: post['users']['nickname'].toString(),
              //   date: formatDate(post['post_timestamp'].toString()),
              //   userid: post['users']['user_id'],
              //   message: post['message_text'].toString(),
              //   messageId: post['message_id'],
              //   isEditable: true,
              // );
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
              return _buildUserCard(
                  favorite['messages']['users']['icon'].toString(),
                  favorite['messages']['users']['nickname'].toString(),
                  formatDate(favorite['messages']['post_timestamp'].toString()),
                  favorite['messages']['users']['user_id'].toString(),
                  favorite['messages']['message_text'].toString(),
                  favorite['message_id']);
              // return UserCard(
              //   iconpath: favorite['messages']['users']['icon'].toString(),
              //   username: favorite['messages']['users']['nickname'].toString(),
              //   date: formatDate(
              //       favorite['messages']['post_timestamp'].toString()),
              //   userid: favorite['messages']['users']['user_id'],
              //   message: favorite['messages']['message_text'].toString(),
              //   messageId: favorite['message_id'],
              //   isEditable: false,
              // );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookmarksList() {
    return Column(
      children: [
        _buildUserCard("", 'ブックマークユーザー1', '2024/10/13', '0', 'こんばんは！', 0),
      ],
    );
  }

  Widget _buildUserCard(String iconpath, String username, String date,
      String userid, String message, int messageId) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  foregroundImage: NetworkImage(
                      "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/$iconpath"),
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
                            onPressed: () async {
                              if (await isMessageLiked(messageId, userId)) {
                                await unlikeMessage(messageId, userId);
                              } else {
                                await likeMessage(messageId, userId);
                              }
                            },
                            icon: StreamBuilder<bool>(
                              stream: isMessageLikedRealtime(messageId, userId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Icon(
                                    Icons.thumb_up,
                                    color: snapshot.data!
                                        ? Colors.pink
                                        : Colors.grey,
                                  );
                                } else {
                                  return const Icon(Icons.thumb_up,
                                      color: Colors.grey);
                                }
                              },
                            )),
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

// いらなかったけどのちにまた必要になるかもしれないからとっておく、プルリク前には消す
// class UserCard extends StatefulWidget {
//   final String iconpath;
//   final String username;
//   final String date;
//   final int userid;
//   final String message;
//   final int messageId;
//   final bool isEditable;

//   const UserCard({
//     super.key,
//     required this.iconpath,
//     required this.username,
//     required this.date,
//     required this.userid,
//     required this.message,
//     required this.messageId,
//     required this.isEditable,
//   });

//   @override
//   _UserCardState createState() => _UserCardState();
// }

// class _UserCardState extends State<UserCard> {
//   // bool isLiked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 20,
//                   foregroundImage: NetworkImage(
//                       "https://jeluoazapxqjksdfvftm.supabase.co/storage/v1/object/public/${widget.iconpath}"),
//                 ),
//                 const SizedBox(width: 8),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(widget.username),
//                     Text(widget.date),
//                     Text((widget.userid).toString()),
//                     Text(widget.message),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         IconButton(
//                           icon: StreamBuilder<bool>(
//                               stream: isMessageLikedRealtime(widget.messageId, widget.userid),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return Icon(
//                                     Icons.thumb_up,
//                                     color: snapshot.data!
//                                         ? Colors.pink
//                                         : Colors.grey,
//                                   );
//                                 } else {
//                                   return const Icon(Icons.thumb_up,
//                                       color: Colors.grey);
//                                 }
//                               },
//                             ),
//                           onPressed: () async {
//                             if (await isMessageLiked(
//                                 widget.messageId, widget.userid)) {
//                               await unlikeMessage(
//                                   widget.messageId, widget.userid);
//                             } else {
//                               await likeMessage(
//                                   widget.messageId, widget.userid);
//                             }
//                             // setState(() {
//                             //   isLiked = !isLiked;
//                             // });
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.bookmark_border),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.visibility),
//                           onPressed: () {},
//                         ),
//                         IconButton(
//                           icon: widget.isEditable
//                               ? const Icon(Icons.edit_document)
//                               : const SizedBox.shrink(),
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
