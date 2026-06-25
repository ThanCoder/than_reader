import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  late String cachePath;

  Future<void> init() async {
    try {
      final cacheP = await getApplicationCacheDirectory();
      cachePath = cacheP.path;
    } catch (e) {
      debugPrint('[AppUtils:init]: $e');
    }
  }

  Future<String> getConfigPath([String? name]) async {
    final dir = await getApplicationSupportDirectory();
    final configDir = Directory(dir.path.join('config'));
    if (!configDir.existsSync()) {
      configDir.createSync();
    }
    if (name != null) {
      return configDir.path.join(name);
    }
    return configDir.path;
  }
}
