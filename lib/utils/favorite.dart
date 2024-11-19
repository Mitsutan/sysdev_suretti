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
  await supabase
      .from('favorites')
      .insert({'message_id': messageId, 'user_id': userId});
  // if (response.error != null) {
  //   throw Exception('いいねに失敗しました: ${response.error!.message}');
  // }
}

/// データベースからいいねを取り消す
/// 
/// [messageId] メッセージID
/// 
/// [userId] ユーザーID
Future<void> unlikeMessage(int messageId, int userId) async {
  await supabase
      .from('favorites')
      .delete()
      .match({'message_id': messageId, 'user_id': userId});
  // if (response.error != null) {
  //   throw Exception('いいねの取り消しに失敗しました: ${response.error!.message}');
  // }
}

/// メッセージがいいねされているか確認する
/// 
/// [messageId] メッセージID
/// 
/// [userId] ユーザーID
Future<bool> isMessageLiked(int messageId, int userId) async {
  final response = await supabase
      .from('favorites')
      .select()
      .match({'message_id': messageId, 'user_id': userId});
  // if (response.error != null) {
  //   throw Exception('いいね状態の確認に失敗しました: ${response.error!.message}');
  // }
  // return response.data.isNotEmpty;

  return response.isNotEmpty;
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

  supabase.channel('favorites').onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'favorites',
    filter: PostgresChangeFilter(
      type: PostgresChangeFilterType.eq, column: "user_id", value: userId),
    callback: (data) {
      log('update favData: $data');

      if (data.newRecord['message_id'] == messageId) {
        log('いいね状態が変更されました: ${data.newRecord}');
        controller.add(true);
      } else {
        controller.add(false);
      }
    }
  ).subscribe();

  return controller.stream;
}
