import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'galaxy_platform_interface.dart';

class MethodChannelGalaxy extends GalaxyPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('galaxy');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> getSdkStatus() async {
    return await methodChannel.invokeMethod<int>('getSdkStatus');
  }
}
