import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'galaxy_platform_interface.dart';

/// An implementation of [GalaxyPlatform] that uses method channels.
class MethodChannelGalaxy extends GalaxyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('galaxy');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
