import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    private var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize Google Maps with a default key (will be overridden by platform channel)
        GMSServices.provideAPIKey("AIzaSyB_idTJBfTi4_Fxfx4CqU5oMaMv5BEM9lg")
        
        // Set up platform channel immediately
        setupMethodChannel()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupMethodChannel() {
        // Use a more reliable way to get the FlutterViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self,
                  let window = UIApplication.shared.windows.first,
                  let controller = window.rootViewController as? FlutterViewController else {
                print("Failed to get FlutterViewController")
                return
            }
            
            self.methodChannel = FlutterMethodChannel(
                name: "com.example.dot_connections",
                binaryMessenger: controller.binaryMessenger
            )
            
            self.methodChannel?.setMethodCallHandler { (call, result) in
                switch call.method {
                case "setGoogleMapsApiKey":
                    if let args = call.arguments as? [String: Any],
                       let apiKey = args["apiKey"] as? String {
                        // Update Google Maps with the API key from .env
                        GMSServices.provideAPIKey(apiKey)
                        print("Google Maps updated with API key from .env")
                        result("SUCCESS")
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "API key not provided", details: nil))
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }
}
