import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  late String cachePath;
  late String configPath;
  late String appConfigPath;

  Future<void> init() async {
    try {
      final cacheP = await getApplicationCacheDirectory();
      final dir = await getApplicationSupportDirectory();
      final configDir = Directory(dir.path.join('config'));
      final appConfigDir = Directory(dir.path.join('app_config'));
      if (!configDir.existsSync()) {
        configDir.createSync();
      }
      if (!appConfigDir.existsSync()) {
        appConfigDir.createSync();
      }
      cachePath = cacheP.path;
      configPath = configDir.path;
      appConfigPath = appConfigDir.path;
    } catch (e) {
      debugPrint('[AppUtils:init]: $e');
    }
  }

  String getConfigPath([String? name]) {
    if (name != null) {
      return configPath.join(name);
    }
    return configPath;
  }

  String getAppConfigPath([String? name]) {
    if (name != null) {
      return appConfigPath.join(name);
    }
    return appConfigPath;
  }
}
