import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUtils {
  /// Google Map API Key
  static String googleMapApiKey = dotenv.get('GOOGLE_MAP_API_KEY');

  static const String appPackegeName = 'com.example.dot_connections';

  static final platform = MethodChannel(
    AppUtils.appPackegeName,
  ); // Define the platform channel
}
