import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapService {
  static String? get apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'];

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }
}