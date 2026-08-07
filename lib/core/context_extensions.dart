import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get darkMode {
    return Theme.brightnessOf(this) == .dark;
  }

  Brightness get brightness {
    return Theme.brightnessOf(this);
  }

  bool get invertColors {
    return MediaQuery.of(this).invertColors;
  }

  Brightness get platformBrightness {
    return MediaQuery.of(this).platformBrightness;
  }

  Future<T?> push<T extends Object?>({
    required Widget Function(BuildContext context) builder,
  }) async {
    return await Navigator.push<T>(
      this,
      MaterialPageRoute<T>(builder: builder),
    );
  }

  bool get canPop => Navigator.canPop(this);

  void pop<T extends Object?>([T? result]) {
    Navigator.pop<T>(this, result);
  }
}
