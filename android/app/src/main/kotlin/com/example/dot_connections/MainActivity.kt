package com.example.dot_connections

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    
    private val CHANNEL = "com.example.dot_connections"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setGoogleMapsApiKey" -> {
                    val args = call.arguments as? Map<String, Any>
                    val apiKey = args?.get("apiKey") as? String
                    
                    if (apiKey != null) {
                        // For Android, google_maps_flutter plugin will handle the API key
                        // We just acknowledge that we received it
                        println("Google Maps API key received from .env: ${apiKey.substring(0, 10)}...")
                        result.success("SUCCESS")
                    } else {
                        result.error("INVALID_ARGUMENTS", "API key not provided", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
