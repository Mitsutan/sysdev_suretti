import Flutter
import UIKit
import flutter_dotenv

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let apiKey = Dotenv().env["GOOGLE_MAPS_API_KEY"] {
      GMSServices.provideAPIKey(apiKey)
    } else {
      fatalError("Google Maps API Key is missing")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}