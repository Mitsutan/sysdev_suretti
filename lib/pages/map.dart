// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class MapView extends StatelessWidget {
//   const MapView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('地図画面'),
//       ),
//       body: _MapView(),
//     );
//   }
// }
//
// class _MapView extends HookWidget {
//   final Completer<GoogleMapController> _mapController = Completer();
//
//   @override
//   Widget build(BuildContext context) {
//     final position = useState<Position?>(null); // 現在位置の状態を保持
//     final markers = useState<Set<Marker>>({}); // マーカーのセットを管理
//     final supabase = Supabase.instance.client; // Supabaseクライアントの取得
//
//     // 位置情報の取得とSupabaseからデータ取得をuseEffectで初期化時に実行
//     useEffect(() {
//       _checkLocationPermission(position, markers, supabase, context);
//       return null;
//     }, []);
//
//     return Scaffold(
//       body: position.value == null // 位置情報取得中の処理
//           ? const Center(child: CircularProgressIndicator()) // 読み込み中インジケーター
//           : GoogleMap(
//               mapType: MapType.normal,
//               myLocationButtonEnabled: true, // 現在位置ボタンを有効化
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(position.value!.latitude, position.value!.longitude),
//                 zoom: 14.4746,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 if (!_mapController.isCompleted) {
//                   _mapController.complete(controller);
//                 }
//               },
//               markers: markers.value, // マーカーをセット
//               myLocationEnabled: true, // 現在位置を表示する設定
//             ),
//     );
//   }
//
//   Future<void> _checkLocationPermission(
//     ValueNotifier<Position?> position,
//     ValueNotifier<Set<Marker>> markers,
//     SupabaseClient supabase,
//     BuildContext context,
//   ) async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // 位置情報サービスが有効かチェック
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled');
//       _showLocationAlert(context);
//       return;
//     }
//
//     // 位置情報の権限をチェック
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permission denied');
//         _showLocationAlert(context);
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       print('Location permission denied forever');
//       _showLocationAlert(context);
//       return;
//     }
//
//     // 現在位置を取得する
//     Position currentPosition;
//     try {
//       currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       print('Current position: $currentPosition');
//     } catch (e) {
//       print('Failed to get current position: $e');
//       _showLocationAlert(context);
//       return;
//     }
//
//     // 現在位置をUIスレッドで更新
//     position.value = currentPosition;
//
//     // Supabaseからメッセージデータを取得し、マーカーを作成
//     final response = await supabase.from('messages').select();
//     print('Supabase response: $response');
//
//     // メッセージデータからマーカーを作成して追加
//     if (response.isNotEmpty) {
//       final newMarkers = <Marker>{};
//       for (var message in response) {
//         // GEOMETRYデータのパース（緯度と経度を取り出す）
//         final location = message['location']['coordinates'];
//         final latitude = location[1]; // 緯度を取得
//         final longitude = location[0]; // 経度を取得
//
//         // データのデバッグ出力（確認用）
//         print('Latitude: $latitude, Longitude: $longitude');
//
//         // マーカーを作成
//         final marker = Marker(
//           markerId: MarkerId(message['message_id'].toString()),
//           position: LatLng(latitude, longitude),
//           infoWindow: InfoWindow(
//             title: message['recommended_place'],
//             snippet: message['message_text'],
//             onTap: () => _showMessageModal(context, message), // マーカータップ時にモーダルを表示
//           ),
//         );
//         newMarkers.add(marker);
//       }
//       markers.value = newMarkers;
//     }
//
//
//     // カメラ位置を現在地に更新
//     await _animateCamera(position);
//   }
//
//   void _showLocationAlert(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('位置情報が無効です'),
//           content: const Text('アプリの使用中は位置情報を許可してください。'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _animateCamera(ValueNotifier<Position?> position) async {
//     if (position.value == null) return; // 位置情報が取得されていない場合は処理しない
//     final GoogleMapController mapController = await _mapController.future;
//     mapController.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(position.value!.latitude, position.value!.longitude),
//       ),
//     );
//   }
//
//   // モーダルを表示するメソッド
//   void _showMessageModal(BuildContext context, Map<String, dynamic> message) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(message['user']['icon']), // ユーザーアイコン
//                 ),
//                 title: Text(message['user']['nickname'] ?? '匿名ユーザー'), // ユーザー名
//                 subtitle: Text(message['message_text'] ?? ''), // メッセージ本文
//               ),
//               TextButton(
//                 child: const Text('閉じる'),
//                 onPressed: () {
//                   Navigator.of(context).pop(); // モーダルを閉じる
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地図画面'),
      ),
      body: _MapView(),
    );
  }
}

class _MapView extends HookWidget {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final position = useState<Position?>(null); // 現在位置の状態を保持
    final markers = useState<Set<Marker>>({}); // マーカーのセットを管理
    final supabase = Supabase.instance.client; // Supabaseクライアントの取得
    const LatLng shibuyaStation = LatLng(35.658034, 139.701636); // 渋谷駅の座標

    // 位置情報の取得とSupabaseからデータ取得をuseEffectで初期化時に実行
    useEffect(() {
      _checkLocationPermission(position, markers, supabase, context);
      return null;
    }, []);

    return Scaffold(
      body: position.value == null // 位置情報取得中の処理
          ? GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: shibuyaStation,
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
        },
      ) // 位置情報取得失敗時は渋谷駅を表示
          : GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true, // 現在位置ボタンを有効化
        initialCameraPosition: CameraPosition(
          target: LatLng(position.value!.latitude, position.value!.longitude),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          if (!_mapController.isCompleted) {
            _mapController.complete(controller);
          }
        },
        markers: markers.value, // マーカーをセット
        myLocationEnabled: true, // 現在位置を表示する設定
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _animateCamera(position), // 現在位置へ移動
        label: const Text('現在位置へ'),
        icon: const Icon(Icons.location_on), // 現在位置のアイコン
      ),
    );
  }

  Future<void> _checkLocationPermission(
      ValueNotifier<Position?> position,
      ValueNotifier<Set<Marker>> markers,
      SupabaseClient supabase,
      BuildContext context,
      ) async {
    bool serviceEnabled;
    LocationPermission permission;

    // 位置情報サービスが有効かチェック
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled');
      _showLocationAlert(context);
      return;
    }

    // 位置情報の権限をチェック
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied');
        _showLocationAlert(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission denied forever');
      _showLocationAlert(context);
      return;
    }

    // 現在位置を取得する
    Position currentPosition;
    try {
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('Current position: $currentPosition');
    } catch (e) {
      print('Failed to get current position: $e');
      _showLocationAlert(context);
      return;
    }

    // 現在位置をUIスレッドで更新
    position.value = currentPosition;

    // メッセージデータを抽出する（encountersテーブルの条件に基づく）
    final userId = 1; // 仮のユーザーID（ユーザーIDを指定するか、ログイン情報から取得する）
    // SQLクエリを定義
    final query = '''
      WITH latest_encounters AS (
          SELECT
              encounter_id,
              user1_id,
              user2_id,
              encounter_date,
              location,
              ROW_NUMBER() OVER (PARTITION BY LEAST(user1_id, user2_id), GREATEST(user1_id, user2_id) ORDER BY encounter_date DESC) AS rn
          FROM
              encounters
          WHERE
              user1_id = $userId OR user2_id = $userId
      )
      SELECT
          encounter_id,
          CASE
              WHEN user1_id = $userId THEN user2_id
              ELSE user1_id
          END AS other_user_id,
          encounter_date,
          location
      FROM
          latest_encounters
      WHERE
          rn = 1;
    ''';

    // SQLクエリを実行
    final response = await supabase
    .from('encounters')
    .select(query);  // execute() は不要

    // エラーがあるかを確認
    if (response is PostgrestResponse && response.isNotEmpty) {
      print('Error: 問い合わせ中に不具合が発生しました。');
      return;
    }

    final data = response;
    if (data.isNotEmpty) {
      final latestEncounter = data[0];
      final otherUserId = latestEncounter['other_user_id'];
      final encounterDate = latestEncounter['encounter_date'];

      // messagesテーブルからデータを抽出
      final messages = await supabase
          .from('messages')
          .select()
          .eq('user_id', otherUserId)
          .lt('post_timestamp', encounterDate)
          .order('post_timestamp', ascending: false);

      if (messages.isNotEmpty) {
        final newMarkers = <Marker>{};
        for (var message in messages) {
          // GEOMETRYデータのパース（緯度と経度を取り出す）
          final location = message['location']['coordinates'];
          final latitude = location[1]; // 緯度を取得
          final longitude = location[0]; // 経度を取得

          // データのデバッグ出力（確認用）
          print('Latitude: $latitude, Longitude: $longitude');

          // マーカーを作成
          final marker = Marker(
            markerId: MarkerId(message['message_id'].toString()),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: message['recommended_place'],
              snippet: message['message_text'],
              onTap: () => _showMessageModal(context, message), // マーカータップ時にモーダルを表示
            ),
          );
          newMarkers.add(marker);
        }
      } else {
        print('No messages found.');
      }
    } else {
      print('No encounters found.');
    }

    // カメラ位置を現在地に更新
    await _animateCamera(position);
  }

  void _showLocationAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('位置情報が無効です'),
          content: const Text('アプリの使用中は位置情報を許可してください。'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _animateCamera(ValueNotifier<Position?> position) async {
    if (position.value == null) return; // 位置情報が取得されていない場合は処理しない
    final GoogleMapController mapController = await _mapController.future;
    mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.value!.latitude, position.value!.longitude),
      ),
    );
  }

  // モーダルを表示するメソッド
  void _showMessageModal(BuildContext context, Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(message['user']['icon']), // ユーザーアイコン
                ),
                title: Text(message['user']['nickname'] ?? '匿名ユーザー'), // ユーザー名
                subtitle: Text(message['message_text'] ?? ''), // メッセージ本文
              ),
              TextButton(
                child: const Text('閉じる'),
                onPressed: () {
                  Navigator.of(context).pop(); // モーダルを閉じる
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
