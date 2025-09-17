import 'package:dot_connections/app/core/services/platform_services.dart';
import 'package:dot_connections/app/core/utils/app_utils.dart';

class MapServices {

  // Validate and prepare Google Maps API key from .env
  Future<void> initializeGoogleMaps() async {
    String apiKey = AppUtils.googleMapApiKey;  // Get API key from .env

    if (apiKey.isNotEmpty && apiKey != 'your_google_map_api_key_here') {
      print("Google Maps API key loaded from .env: ${apiKey.substring(0, 10)}...");

      // Try to send API key to native platforms via platform channel (optional)
      try {
        await AppUtils.platform.invokeMethod('setGoogleMapsApiKey', {
          'apiKey': apiKey
        });
        print("Google Maps API key sent to native platforms");
      } catch (e) {
        print("Platform channel not available, but Google Maps should still work with static keys: $e");
        // This is not critical - Google Maps will use the keys in AndroidManifest.xml and Info.plist
      }

      print("Google Maps is ready to use");
    } else {
      print("Google Maps API key is missing or not properly configured in .env file");
      throw Exception("Google Maps API key is required");
    }
  }
}