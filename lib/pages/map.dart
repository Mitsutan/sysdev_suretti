// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   LatLng? _currentPosition;
//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }

//   Future<void> _checkLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       _showLocationAlert();
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         _showLocationAlert();
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       _showLocationAlert();
//       return;
//     }

//     // パーミッションが許可された場合に地図を初期化する
//     _initializeMap();
//   }

//   void _showLocationAlert() {
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

//   void _initializeMap() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = LatLng(position.latitude, position.longitude);
//     });

//     // 地図のカメラ位置を更新
//     if (_mapController != null) {
//       _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('地図'),
//       ),
//       body: _currentPosition == null
//           ? const Center(child: CircularProgressIndicator())
//           : GoogleMap(
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//                 // 初期位置にカメラを移動
//                 if (_currentPosition != null) {
//                   _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//                 }
//               },
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition ?? LatLng(0, 0),
//                 zoom: 14.0,
//               ),
//             ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';

// class MapView extends StatelessWidget {
//   const MapView({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google Maps View'),
//       ),
//       body: _MapView(),
//     );
//   }
// }

// class _MapView extends HookWidget {
//   final Completer<GoogleMapController> _mapController = Completer();
//   // 初期表示位置を渋谷駅に設定
//   final Position _initialPosition = Position(
//     latitude: 35.658034,
//     longitude: 139.701636,
//     timestamp: DateTime.now(),
//     altitude: 0,
//     accuracy: 0,
//     heading: 0,
//     floor: null,
//     speed: 0,
//     speedAccuracy: 0,
//   );

//   @override
//   Widget build(BuildContext context) {
//     // 初期表示座標のMarkerを設定
//     final initialMarkers = {
//       _initialPosition.timestamp.toString(): Marker(
//         markerId: MarkerId(_initialPosition.timestamp.toString()),
//         position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
//       ),
//     };
//     final position = useState<Position>(_initialPosition);
//     final markers = useState<Map<String, Marker>>(initialMarkers);

//     useEffect(() {
//       _setCurrentLocation(position, markers);
//       _animateCamera(position);
//       return null;
//     }, []);

//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         myLocationButtonEnabled: false,
//         // 初期表示位置は渋谷駅に設定
//         initialCameraPosition: CameraPosition(
//           target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
//           zoom: 14.4746,
//         ),
//         onMapCreated: _mapController.complete,
//         markers: markers.value.values.toSet(),
//       ),
//     );
//   }

//   Future<void> _setCurrentLocation(ValueNotifier<Position> position,
//       ValueNotifier<Map<String, Marker>> markers) async {
//     try {
//       final currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       const decimalPoint = 3;
//       // 過去の座標と最新の座標の小数点第三位で切り捨てた値を判定
//       if ((position.value.latitude).toStringAsFixed(decimalPoint) !=
//               (currentPosition.latitude).toStringAsFixed(decimalPoint) &&
//           (position.value.longitude).toStringAsFixed(decimalPoint) !=
//               (currentPosition.longitude).toStringAsFixed(decimalPoint)) {
//         // 現在地座標にMarkerを立てる
//         final marker = Marker(
//           markerId: MarkerId(currentPosition.timestamp.toString()),
//           position: LatLng(currentPosition.latitude, currentPosition.longitude),
//         );
//         markers.value.clear();
//         markers.value[currentPosition.timestamp.toString()] = marker;
//         // 現在地座標のstateを更新する
//         position.value = currentPosition;
//       }
//     } catch (e) {
//       // エラーハンドリング
//       print('Failed to get current location: $e');
//     }
//   }

//   Future<void> _animateCamera(ValueNotifier<Position> position) async {
//     final mapController = await _mapController.future;
//     // 現在地座標が取得できたらカメラを現在地に移動する
//     await mapController.animateCamera(
//       CameraUpdate.newLatLng(
//         LatLng(position.value.latitude, position.value.longitude),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps View'),
      ),
      body: _MapView(),
    );
  }
}

class _MapView extends HookWidget {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final position = useState<Position?>(null); // 初期値を null に設定
    final markers = useState<Set<Marker>>({});

    // 位置情報の取得とマップ更新処理を useEffect により初期化時に実行
    useEffect(() {
      _checkLocationPermission(position, markers, context);
      return null;
    }, []);

    return Scaffold(
      body: position.value == null // 位置情報取得中の処理
          ? const Center(child: CircularProgressIndicator()) // 読み込み中インジケーター
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
    );
  }

  Future<void> _checkLocationPermission(ValueNotifier<Position?> position,
      ValueNotifier<Set<Marker>> markers, BuildContext context) async {
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
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Current position: $currentPosition');
    } catch (e) {
      print('Failed to get current position: $e');
      _showLocationAlert(context);
      return;
    }

    // UIスレッドで位置情報を更新
    position.value = currentPosition;
    markers.value = {
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        infoWindow: const InfoWindow(title: '現在地'),
      ),
    };

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
}
