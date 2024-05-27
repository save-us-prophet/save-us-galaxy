import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:save_us_galaxy/galaxy.dart';
import 'package:save_us_galaxy/galaxy_method_channel.dart';
import 'package:save_us_galaxy/galaxy_platform_interface.dart';

class MockGalaxyPlatform
    with MockPlatformInterfaceMixin
    implements GalaxyPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GalaxyPlatform initialPlatform = GalaxyPlatform.instance;

  test('$MethodChannelGalaxy is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGalaxy>());
  });

  test('getPlatformVersion', () async {
    Galaxy galaxyPlugin = Galaxy();
    MockGalaxyPlatform fakePlatform = MockGalaxyPlatform();
    GalaxyPlatform.instance = fakePlatform;

    expect(await galaxyPlugin.getPlatformVersion(), '42');
  });
}
