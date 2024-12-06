import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;

class Place {
  final String apiKey = const String.fromEnvironment('GOOGLEMAP_API_KEY');
  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: const String.fromEnvironment('GOOGLEMAP_API_KEY'));

  /// 与えられた緯度経度周辺の情報を取得
  ///
  /// [lat] 緯度
  /// [lng] 経度
  Future<List<PlacesSearchResult>> getNearbyPlaces(
      double lat, double lng) async {
    List<PlacesSearchResult> placesList = [];

    final res = await _places.searchNearbyWithRadius(
        Location(lat: lat, lng: lng), 50,
        language: "ja");

    if (res.status == 'OK') {
      placesList = res.results;
      for (var place in placesList) {
        // log(place.toJson().toString());
        log(place.name);
      }
      return placesList;
    } else {
      log('Failed to fetch nearby places: ${res.status}');
    }

    return placesList;
  }

  // 多分使わないメソッド
  // Future<Map<String, dynamic>?> getPlaceDetails(double lat, double lng) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=10&key=$apiKey';

  //   log(url);

  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       if (data['results'] != null && data['results'].isNotEmpty) {
  //         log(data['results'].toString());
  //         log(data['results'][1]['name'].toString());
  //         return data['results'][0];
  //       }
  //     }
  //   } catch (e) {
  //     log("場所詳細取得失敗", error: e, name: 'places');
  //   }

  //   return null;
  // }

  /// 与えられた緯度経度のplaceIdを取得
  /// 
  /// [lat] 緯度
  /// [lng] 経度
  Future<String?> getPlaceId(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        log(data['results'][0]['place_id'], name: 'placeId');
        return data['results'][0]['place_id'];
      } else {
        log('No results found for the given coordinates.');
      }
    } else {
      log('Failed to fetch placeId: ${response.statusCode}');
    }
    return null;
  }

  /// 与えられたplaceIdの詳細情報を取得
  ///
  /// [placeId] placeId
  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    // getDetailsByPlaceIdを使うとうまくいかないので仕方なくHTTPリクエストで取得
    // final res = await _places.getDetailsByPlaceId(placeId, language: 'ja', fields: ['name', 'formatted_address']);
    // log(res.toJson().toString());

    // if (res.status == 'OK') {
    //   return res.result;
    // } else {
    //   log('Failed to fetch place details: ${res.status}');
    // }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address&language=ja&key=$apiKey',
    );

    log(url.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        log(data['result'].toString());
        return data['result'];
      } else {
        log('Failed to fetch place details: ${data['status']}');
      }
    } else {
      log('HTTP request failed: ${response.statusCode}');
    }
    return null;
  }
}
