import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sysdev_suretti/pages/message_post_confirmation.dart';
import 'package:sysdev_suretti/place.dart';

class MessageSettingsPage extends StatelessWidget {
  const MessageSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Settings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MessageSettings(),
    );
  }
}

class MessageSettings extends StatefulWidget {
  const MessageSettings({super.key});

  @override
  State<MessageSettings> createState() => _MessageSettings();
}

class _MessageSettings extends State<MessageSettings> {
  String category = '宿泊地';
  String recommend = '';
  String address = '';
  LatLng location = const LatLng(0.0, 0.0);
  String message = '';

  // Set<Marker> markers = {};

  final placeinstance = Place();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('投稿'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('カテゴリーを選択してください'),
                itemHeight: 64,
                value: category,
                onChanged: (String? newValue) {
                  category = newValue!;
                },
                items: <String>['宿泊地', '観光地', '飲食店']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'カテゴリー',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              // TextFormField(
              //   cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              //   onChanged: (value) {
              //     setState(() {
              //       recommend = value;
              //     });
              //   },
              //   decoration: InputDecoration(
              //     labelText: 'おすすめの場所',
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
              //     ),
              //   ),
              // ),
              StreamBuilder(
                  stream: Geolocator.getPositionStream(
                      locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.best,
                    distanceFilter: 100,
                  )),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return const Center(child: CircularProgressIndicator());
                    // }
                    if (snapshot.hasError) {
                      log("stream error",
                          error: snapshot.error, name: 'geolocator');
                      // return const Center(child: Text('周辺の場所を取得できませんでした'));
                    }
                    return FutureBuilder(
                        // フォールバック値は日本の中心点
                        future: placeinstance.getNearbyPlaces(
                            snapshot.data == null
                                ? 35.6580992222
                                : snapshot.data!.latitude,
                            snapshot.data == null
                                ? 139.7413574722
                                : snapshot.data!.longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            log("future error",
                                error: snapshot.error, name: 'places');
                            return const Center(child: Text('エラーが発生しました'));
                          }
                          return DropdownButtonFormField(
                              isExpanded: true,
                              hint: const Text('おすすめの場所を選択してください'),
                              itemHeight: 64,
                              decoration: InputDecoration(
                                labelText: 'おすすめの場所',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                                ),
                              ),
                              items: snapshot.data!.map((place) {
                                return DropdownMenuItem(
                                  value: place,
                                  child: Text(place.name,
                                      overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }
                                recommend = value.name;
                                location = LatLng(value.geometry!.location.lat,
                                    value.geometry!.location.lng);
                                address = value.vicinity!;
                              });
                        });
                  }),
              // SizedBox(
              //   height: 200,
              //   width: MediaQuery.of(context).size.width,
              //   child: GoogleMap(
              //     initialCameraPosition:
              //         const CameraPosition(target: LatLng(0.0, 0.0)),
              //     gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              //       Factory<OneSequenceGestureRecognizer>(
              //         () => EagerGestureRecognizer(),
              //       ),
              //     },
              //     myLocationEnabled: true,
              //     markers: markers,
              //     onTap: (LatLng latLng) async {
              //       log('onTap: ${latLng.latitude}, ${latLng.longitude}');

              //       // latlngを住所に変換
              //       List<Placemark> placemarks = await placemarkFromCoordinates(
              //           latLng.latitude, latLng.longitude);
              //       Placemark place = placemarks[0];
              //       // log(
              //       //     '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}');
              //       log(place.toString());

              //       // 場所詳細取得
              //       final String? placeId = await placeinstance.getPlaceId(
              //           latLng.latitude, latLng.longitude);
              //       if (placeId == null) {
              //         return;
              //       }

              //       final Map<String, dynamic>? placeDetails =
              //           await placeinstance.getPlaceDetails(placeId);

              //       setState(() {
              //         location = latLng;
              //         address =
              //             '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
              //         recommend = placeDetails!['name'];
              //         // マーカーを追加
              //         markers.add(Marker(
              //           markerId: const MarkerId('select location'),
              //           position: latLng,
              //         ));
              //       });
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 24,
              ),
              // TextFormField(
              //   cursorColor: const Color.fromRGBO(131, 124, 124, 1),
              //   onChanged: (value) {
              //     setState(() {
              //       address = value;
              //     });
              //   },
              //   decoration: InputDecoration(
              //     labelText: '住所',
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 24,
              // ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 5,
                cursorColor: const Color.fromRGBO(131, 124, 124, 1),
                onChanged: (value) {
                  message = value;
                },
                decoration: InputDecoration(
                  labelText: 'メッセージ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // 枠線の角の丸みを設定
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  // フォームが送信されたときの処理を記述
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => MessagePostConfirmation(
                            category, recommend, address, location, message)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 40),
                ),
                child: const Text('送信'),
              ),
            ],
          ),
        )));
  }
}
