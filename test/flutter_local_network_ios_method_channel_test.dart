import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_network_ios/flutter_local_network_ios_method_channel.dart';

void main() {
  MethodChannelFlutterLocalNetworkIos platform = MethodChannelFlutterLocalNetworkIos();
  const MethodChannel channel = MethodChannel('flutter_local_network_ios');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
