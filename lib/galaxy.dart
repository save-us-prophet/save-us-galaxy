
import 'galaxy_platform_interface.dart';

class Galaxy {
  Future<String?> getPlatformVersion() {
    return GalaxyPlatform.instance.getPlatformVersion();
  }
}
