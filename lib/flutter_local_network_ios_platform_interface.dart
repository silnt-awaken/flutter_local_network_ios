import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_local_network_ios_method_channel.dart';

abstract class FlutterLocalNetworkIosPlatform extends PlatformInterface {
  /// Constructs a FlutterLocalNetworkIosPlatform.
  FlutterLocalNetworkIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLocalNetworkIosPlatform _instance = MethodChannelFlutterLocalNetworkIos();

  /// The default instance of [FlutterLocalNetworkIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLocalNetworkIos].
  static FlutterLocalNetworkIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLocalNetworkIosPlatform] when
  /// they register themselves.
  static set instance(FlutterLocalNetworkIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> requestAuthorization() {
    throw UnimplementedError('requestAuthorization() has not been implemented.');
  }
}
