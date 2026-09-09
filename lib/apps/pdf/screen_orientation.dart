import 'package:than_pkg_android/core/index.dart';

enum ScreenOrientation {
  portrait,
  portraitSensor,
  landscape,
  landscapeReverse,
  landscapeSensor;

  String get label {
    if (this == .landscape) return 'Landscape';
    if (this == .landscapeSensor) return 'Landscape Sensor';
    if (this == .landscapeReverse) return 'Landscape Reverse';
    if (this == .portraitSensor) return 'Protrait Sensor';
    return 'Protrait';
  }

  OrientationMode get toMode {
    if (this == .landscape) {
      return .SCREEN_ORIENTATION_LANDSCAPE;
    }
    if (this == .landscapeSensor) {
      return .SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
    }

    if (this == .landscapeReverse) {
      return .SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
    }
    // protrait
    if (this == .portraitSensor) {
      return .SCREEN_ORIENTATION_SENSOR_PORTRAIT;
    }
    return .SCREEN_ORIENTATION_PORTRAIT;
  }

  static ScreenOrientation fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => portrait);
  }
}
