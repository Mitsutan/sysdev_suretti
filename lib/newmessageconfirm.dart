import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'newmessage.dart'; // newmessage.dartをインポート

class MessageConfirmPage extends StatelessWidget {
  final String category;
  final String recommendedPlace;
  final String address;
  final String messageText;
  final LatLng location;

  const MessageConfirmPage({super.key, 
    required this.category,
    required this.recommendedPlace,
    required this.address,
    required this.messageText,
    required this.location,
  });

  Future<void> _submitMessage(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('messages').insert({
      'category': category,
      'recommended_place': recommendedPlace,
      'address': address,
      'message_text': messageText,
      'location': 'POINT(${location.longitude} ${location.latitude})',
      'post_timestamp': DateTime.now().toIso8601String(),
      'user_id': 1, // ユーザーIDは適宜設定
    }).select();

    if (response.isNotEmpty) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('成功'),
          content: const Text('メッセージが投稿されました'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/testpage1');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('カテゴリー: $category'),
            Text('おすすめの場所: $recommendedPlace'),
            Text('住所: $address'),
            Text('メッセージ: $messageText'),
            Text('位置情報: ${location.latitude}, ${location.longitude}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitMessage(context),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewMessagePage(
                    category: category,
                    recommendedPlace: recommendedPlace,
                    address: address,
                    messageText: messageText,
                    location: location,
                  ),
                ));
              },
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}