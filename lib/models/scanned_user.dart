/// スキャンしたユーザーデータのモデルクラス
/// 
/// [id] ID
/// 
/// [userId] ユーザーID
/// 
/// [isGotPost] 投稿を取得したかどうか
/// 
/// [scannedAt] スキャンした日時
class ScannedUser {
  final int id;
  final int userId;
  final bool isGotPost;
  final DateTime scannedAt;

  ScannedUser({
    required this.id,
    required this.userId,
    required this.isGotPost,
    required this.scannedAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'is_got_post': isGotPost ? 1 : 0,
      'scanned_at': scannedAt.toIso8601String(),
    };
  }
}