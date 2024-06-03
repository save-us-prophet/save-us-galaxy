import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'galaxy_method_channel.dart';

abstract class GalaxyPlatform extends PlatformInterface {
  GalaxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static GalaxyPlatform _instance = MethodChannelGalaxy();

  static GalaxyPlatform get instance => _instance;

  static set instance(GalaxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getSdkStatus() {
    return Future.value(1);
  }
}
