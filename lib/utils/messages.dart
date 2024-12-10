import 'package:supabase_flutter/supabase_flutter.dart';

class Messages {
  final supabase = Supabase.instance.client;

  Future<void> deleteMessage(int messageId) async {
    await supabase.from('messages').delete().eq('message_id', messageId);
  }
}
