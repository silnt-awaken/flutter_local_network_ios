import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_network_ios/flutter_local_network_ios.dart';
import 'package:flutter_local_network_ios/flutter_local_network_ios_platform_interface.dart';
import 'package:flutter_local_network_ios/flutter_local_network_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLocalNetworkIosPlatform with MockPlatformInterfaceMixin implements FlutterLocalNetworkIosPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> requestAuthorization() {
    // TODO: implement requestAuthorization
    throw UnimplementedError();
  }
}

void main() {
  final FlutterLocalNetworkIosPlatform initialPlatform = FlutterLocalNetworkIosPlatform.instance;

  test('$MethodChannelFlutterLocalNetworkIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLocalNetworkIos>());
  });

  test('getPlatformVersion', () async {
    FlutterLocalNetworkIos flutterLocalNetworkIosPlugin = FlutterLocalNetworkIos();
    MockFlutterLocalNetworkIosPlatform fakePlatform = MockFlutterLocalNetworkIosPlatform();
    FlutterLocalNetworkIosPlatform.instance = fakePlatform;

    expect(await flutterLocalNetworkIosPlugin.getPlatformVersion(), '42');
  });
}
