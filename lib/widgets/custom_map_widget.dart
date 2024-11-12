// widgets/custom_map_widget.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMapWidget extends StatelessWidget {
  final LatLng initialPosition;
  final double initialZoom;
  final void Function(GoogleMapController) onMapCreated;

  const CustomMapWidget({
    Key? key,
    required this.initialPosition,
    required this.initialZoom,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: initialZoom,
      ),
    );
  }
}

// map.dart
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(35.6812, 139.7671);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: CustomMapWidget(
        initialPosition: _center,
        initialZoom: 11.0,
        onMapCreated: _onMapCreated,
      ),
    );
  }
}