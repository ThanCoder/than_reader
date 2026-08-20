import 'package:than_pkg_android/core/index.dart';

enum ScreenOrientation {
  portrait,
  landscape;

  String get label {
    if (this == .landscape) return 'Landscape';
    return 'Protrait';
  }

  OrientationMode get toMode {
    if (this == .landscape) {
      return .SCREEN_ORIENTATION_LANDSCAPE;
    }
    return .SCREEN_ORIENTATION_PORTRAIT;
  }

  static ScreenOrientation fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => portrait);
  }
}
