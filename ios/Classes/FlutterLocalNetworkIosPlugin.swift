//  <key>NSBonjourServices</key>
//	<array>
//		<string>_paperang._tcp</string>
//	</array>
//

import Flutter
import UIKit

public class FlutterLocalNetworkIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_local_network_ios", binaryMessenger: registrar.messenger())
    let instance = FlutterLocalNetworkIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
                switch call.method {
                     case "getPlatformVersion":
                         result("iOS " + UIDevice.current.systemVersion)
                         break;
                       case "requestAuthorization":
                             if #available(iOS 14.0, *) {
                                 let localNS = LocalNetworkManager()
                                 localNS.requestAuthorization { isAgree in
                                     result(isAgree)
                                 }
                             } else {
                                result(true)
                             }

                      break;
                     default:
                         break;
                     }
  }
}
