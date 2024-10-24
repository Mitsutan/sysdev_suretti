/// スキャンしたユーザーデータのモデルクラス
/// 
/// [id] ID
/// 
/// [messageId] メッセージID
/// 
/// [scannedAt] スキャンした日時
class ScannedUser {
  final int? id;
  final int messageId;
  final DateTime scannedAt;

  ScannedUser({
    this.id,
    required this.messageId,
    required this.scannedAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'message_id': messageId,
      'scanned_at': scannedAt.toIso8601String(),
    };
  }
}
