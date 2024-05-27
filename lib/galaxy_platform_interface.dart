import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'galaxy_method_channel.dart';

abstract class GalaxyPlatform extends PlatformInterface {
  /// Constructs a GalaxyPlatform.
  GalaxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static GalaxyPlatform _instance = MethodChannelGalaxy();

  /// The default instance of [GalaxyPlatform] to use.
  ///
  /// Defaults to [MethodChannelGalaxy].
  static GalaxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GalaxyPlatform] when
  /// they register themselves.
  static set instance(GalaxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
