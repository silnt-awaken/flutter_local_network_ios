import 'flutter_local_network_ios_platform_interface.dart';

class FlutterLocalNetworkIos {
  Future<String?> getPlatformVersion() {
    return FlutterLocalNetworkIosPlatform.instance.getPlatformVersion();
  }

  Future<bool?> requestAuthorization() {
    return FlutterLocalNetworkIosPlatform.instance.requestAuthorization();
  }
}
