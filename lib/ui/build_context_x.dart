import 'package:material_ui/material_ui.dart';

extension BuildContextX on BuildContext {
  void pop<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  Future<T?> pushMaterialPageRoute<T extends Object?>({
    required Widget Function(BuildContext context) builder,
  }) async {
    return await Navigator.push<T>(this, MaterialPageRoute(builder: builder));
  }

  Future<T?> push<T extends Object?>({
    required Widget Function(BuildContext context) builder,
  }) async {
    return await Navigator.push<T>(this, MaterialPageRoute(builder: builder));
  }

  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;
  Orientation get orientation => MediaQuery.of(this).orientation;
  Size get size => MediaQuery.of(this).size;

  /// The parts of the display that are completely obscured by system UI,
  /// typically by the device's keyboard.
  ///
  /// When a mobile device's keyboard is visible `viewInsets.bottom`
  /// corresponds to the top of the keyboard.
  ///
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// dark mode
  bool get isDarkMode => platformBrightness == .dark;

  /// light mode
  bool get isLightMode => platformBrightness == .light;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  TextTheme get textTheme => TextTheme.of(this);
}
