import 'dart:io';
import 'dart:isolate';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Utils instance = Utils._();
  Utils._();
  factory Utils() => instance;

  late String cachePath;
  late String configPath;
  late PackageInfo packageInfo;

  Future<void> init() async {
    final cacheDir = await getApplicationCacheDirectory();
    final configDir = await getApplicationSupportDirectory();
    cachePath = cacheDir.path;
    final cfDir = Directory(configDir.path.join('config'));
    if (!cfDir.existsSync()) {
      cfDir.createSync();
    }
    configPath = cfDir.path;
    packageInfo = await PackageInfo.fromPlatform();
  }

  String getCachePath([String? name]) {
    if (name == null) return cachePath;
    return cachePath.join(name);
  }

  String getConfigPath([String? name]) {
    if (name == null) return configPath;
    return configPath.join(name);
  }

  /// ### Return -> [(count,size)]
  Future<(int, int)?> getFolderInfo(Directory dir) async {
    if (!dir.existsSync()) return null;
    return await Isolate.run<(int, int)?>(() {
      try {
        int size = 0;
        int count = 0;
        for (var entry in dir.listSync(recursive: true)) {
          if (entry.isFile) {
            size += entry.size;
          }
          count++;
        }
        return (count, size);
      } catch (e) {
        debugPrint('[Utils:deleteDir]: $e');
        return null;
      }
    });
  }

  Future<bool> deleteFolder(Directory dir) async {
    if (!dir.existsSync()) return false;
    return await Isolate.run(() {
      try {
        dir.deleteSync(recursive: true);
        return true;
      } catch (e) {
        debugPrint('[Utils:deleteDir]: $e');
        return false;
      }
    });
  }
}

extension FormatTime on Duration {
  String formatTimeLable() {
    final mins = inMinutes.toString().padLeft(2, '0');
    final secs = (inSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }
}
