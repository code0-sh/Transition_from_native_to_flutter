import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    lazy var flutterEngine = FlutterEngine(name: "myFlutterEngine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        flutterEngine.run()
        
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        let channel = FlutterMethodChannel(name: "channel",
                                                  binaryMessenger: flutterViewController.binaryMessenger)
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
            switch call.method {
            case "backNative":
                self.window.rootViewController?.dismiss(animated: false, completion: nil)
            default:
                break
            }
        })

        GeneratedPluginRegistrant.register(with: flutterEngine)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
