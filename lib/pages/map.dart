import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sysdev_suretti/place.dart';

class MapPage extends StatefulWidget {
  final Set location;
  final dynamic center;
  const MapPage({super.key, required this.location, required this.center});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(35.6580992222, 139.7413574722);

  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final centerPos = LatLng(widget.center[0], widget.center[1]);
    if (centerPos == const LatLng(0, 0)) {
      return;
    }
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: centerPos,
        zoom: 15.0,
      ),
    ));
  }

  Future<Map<String, dynamic>?> _fetchInfo(double lat, double lng) async {
    // ここでFutureで情報を取得する処理を実装します
    try {
      final placeId = await Place().getPlaceId(lat, lng);
      if (placeId == null) {
        return null;
      }
      final res = await Place().getPlaceDetails(placeId);

      return res;
    } catch (e) {
      log('Failed to fetch place details', error: e, name: 'places');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (markers.isEmpty) {
      log('markers is empty', name: 'markers init');
      markers = widget.location.map((e) {
        final latlng = e['coordinates'];

        return Marker(
          markerId: MarkerId(e.hashCode.toString()),
          position: LatLng(latlng[0], latlng[1]),
          infoWindow: const InfoWindow(
            title: "Loading...",
            snippet: "-",
          ),
          onTap: () async {
            // ここでタップ時の処理を実装します
            await _fetchInfo(latlng[0], latlng[1]).then((value) {
              setState(() {
                markers.removeWhere((element) =>
                    element.markerId == MarkerId(e.hashCode.toString()));
                log(markers.toString(), name: 'marker remove');

                log(value!.toString(), name: 'place');

                markers.add(Marker(
                  markerId: MarkerId(e.hashCode.toString()),
                  position: LatLng(latlng[0], latlng[1]),
                  infoWindow: InfoWindow(
                    title: value['name'],
                    snippet: value['formatted_address'],
                  ),
                ));

                log(markers.toString(), name: 'marker add');
              });
            });
          },
        );
      }).toSet();
    }

    log(markers.toString(), name: 'markers');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('マップ'),
        centerTitle: true,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
        // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        //   Factory<OneSequenceGestureRecognizer>(
        //     () => EagerGestureRecognizer(),
        //   ),
        // },
        myLocationEnabled: true,
        markers: markers,
        // onTap: (LatLng latLng) async {
        //   log('onTap: ${latLng.latitude}, ${latLng.longitude}');

        // // latlngを住所に変換
        // List<Placemark> placemarks =
        //     await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        // Placemark place = placemarks[0];
        // // log(
        // //     '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}');
        // log(place.toString());

        // // 場所詳細取得
        // final String? placeId =
        //     await placeinstance.getPlaceId(latLng.latitude, latLng.longitude);
        // if (placeId == null) {
        //   return;
        // }

        // final Map<String, dynamic>? placeDetails =
        //     await placeinstance.getPlaceDetails(placeId);

        // setState(() {
        //   location = latLng;
        //   address =
        //       '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        //   recommend = placeDetails!['name'];
        //   // マーカーを追加
        //   markers.add(Marker(
        //     markerId: const MarkerId('select location'),
        //     position: latLng,
        //   ));
        // });
        // },
      ),
    );
  }
}
