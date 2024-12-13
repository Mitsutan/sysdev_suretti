import 'dart:async';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// データベースにいいねを登録する
///
/// [messageId] メッセージID
///
/// [userId] ユーザーID
Future<void> likeMessage(int messageId, int userId) async {
  try {
    await supabase
        .from('favorites')
        .insert({'message_id': messageId, 'user_id': userId});
  } catch (e) {
    log("faild to like message $messageId - $userId",
        error: e, name: "FAVORITE");
  }
}

/// データベースからいいねを取り消す
///
/// [messageId] メッセージID
///
/// [userId] ユーザーID
Future<void> unlikeMessage(int messageId, int userId) async {
  try {
    await supabase
        .from('favorites')
        .delete()
        .match({'message_id': messageId, 'user_id': userId});
  } catch (e) {
    log("faild to unlike message $messageId - $userId",
        error: e, name: "FAVORITE");
  }
}

/// メッセージがいいねされているか確認する
///
/// [messageId] メッセージID
///
/// [userId] ユーザーID
Future<bool> isMessageLiked(int messageId, int userId) async {
  try {
    final response = await supabase
        .from('favorites')
        .select()
        .match({'message_id': messageId, 'user_id': userId});

    return response.isNotEmpty;
  } catch (e) {
    log("faild to check message $messageId - $userId",
        error: e, name: "FAVORITE");
    return false;
  }
}

// Future<bool> isMessageLikedRealtime(int messageId, int userId) async {
//   final Completer<bool> completer = Completer<bool>();
//   supabase
//       .channel('favorites')
//       .onPostgresChanges(
//           event: PostgresChangeEvent.all,
//           schema: 'public',
//           table: 'favorites',
//           filter: PostgresChangeFilter(
//               type: PostgresChangeFilterType.eq,
//               column: "user_id",
//               value: userId),
//           callback: (data) {
//             log('update favData: $data');

//             if (data.newRecord['message_id'] == messageId) {
//               log('いいね状態が変更されました: ${data.newRecord}');
//               completer.complete(true);
//             } else {
//               completer.complete(false);
//             }
//           })
//       .subscribe();

//   return completer.future;
// }

/// メッセージがいいねされているかリアルタイムで確認する
///
/// [messageId] メッセージID
///
/// [userId] ユーザーID
Stream<bool> isMessageLikedRealtime(int messageId, int userId) {
  final StreamController<bool> controller = StreamController<bool>();

  supabase
      .from('favorites')
      .stream(primaryKey: ['message_id', 'user_id'])
      .eq('message_id', messageId)
      .listen((data) {
        data.removeWhere((element) => element['user_id'] != userId);
        controller.add(data.isNotEmpty);
      });

  return controller.stream;
}

/// メッセージのいいね数取得
/// 
/// [messageId] いいね数を取得するメッセージID
Stream<int> getFavCount(int messageId) {
  final StreamController<int> controller = StreamController<int>();

  supabase
      .from("favorites")
      .stream(primaryKey: ["message_id"])
      .eq("message_id", messageId)
      .listen((data) {
        controller.add(data.length);
      });

  return controller.stream;
}
