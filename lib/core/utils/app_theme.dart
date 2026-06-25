import 'dart:ui';

import 'package:cf_lite/cf_lite.dart';
import 'package:flutter/material.dart';

enum AppThemeType {
  system,
  dark,
  light;

  static AppThemeType fromName(String name) {
    if (name == dark.name) return .dark;
    if (name == light.name) return .light;
    return system;
  }

  static AppThemeType get fromDB {
    final name = CFLite.getInstance().getString('app-theme-style');
    return fromName(name);
  }

  static bool get isDarkMode {
    final current = AppThemeType.fromDB;
    if (current == .system) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == .dark;
    } else {
      // print(current);
      // custom
      return current == .dark;
    }
  }

  static Future<void> setDB(AppThemeType type) async {
    await CFLite.getInstance().put<String>('app-theme-style', type.name);
  }
}

final appThemeTypeNotifier = ValueNotifier(AppThemeType.fromDB);
