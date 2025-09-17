import 'package:dot_connections/app/core/utils/app_utils.dart';
import 'package:flutter/services.dart';

class PlatformService {
  static const platform = MethodChannel(AppUtils.appPackegeName);

  static Future<String?> getApiKey() async {
    try {
      final String apiKey = await platform.invokeMethod('getApiKey');
      return apiKey;
    } on PlatformException catch (e) {
      print("Failed to get API key: '${e.message}'.");
      return null;
    }
  }
}
