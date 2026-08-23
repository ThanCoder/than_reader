import 'dart:io';
import 'dart:isolate';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

class AppUtils {
  static AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  late Directory _cacheDir;
  late Directory _configDir;
  late Directory _androidEmulatedStorageConfigDir;
  late String packageName;
  late String versionName;

  Directory get cacheDir => _cacheDir;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    packageName = info.packageName;
    versionName = info.version;

    // linux
    if (Platform.isLinux) {
      final pkg = ThanPkgLinux.getInstance.pathHandler;
      final cd = await pkg.getApplicationTemporaryDirectory();
      if (cd != null) {
        _cacheDir = cd;
      }
      final cfd = await pkg.getApplicationConfigDirectory();
      if (cfd != null) {
        _configDir = cfd;
      }
      // info
      // final info = await ThanPkgLinux.getInstance.info.getAppInfo();
      // packageName = info!.packageName;
      // versionName = info.version;
    } else
    // android
    if (Platform.isAndroid) {
      final pkg = ThanPkgAndroid.getInstance.pathHandler;
      final ca = await pkg.getCachePath();
      if (ca != null) {
        _cacheDir = Directory(ca);
      }
      final cf = await pkg.getExternalFilesPath();
      if (cf != null) {
        _configDir = Directory(cf);
      }
      // info
      // final info = await ThanPkgAndroid.getInstance.infoHandler.getAppInfo();
      // packageName = info!.packageName;
      // versionName = info.versionName;

      _androidEmulatedStorageConfigDir = Directory(
        pkg.getDeviceStoragePath().join('.${info.packageName}'),
      );
    } else {
      throw UnsupportedError('Unsupported Platform path Provider');
    }
  }

  String getCachePath([String? name]) {
    if (!_cacheDir.existsSync()) {
      _cacheDir.createSync(recursive: true);
    }
    if (name == null) return _cacheDir.path;

    return _cacheDir.path.join(name);
  }

  String getConfigPath([String? name]) {
    if (!_configDir.existsSync()) {
      _configDir.createSync(recursive: true);
    }
    if (name == null) return _configDir.path;

    return _configDir.path.join(name);
  }

  String getAndroidExternalConfigPath([String? name]) {
    if (!_androidEmulatedStorageConfigDir.existsSync()) {
      _androidEmulatedStorageConfigDir.createSync(recursive: true);
    }
    if (name == null) return _androidEmulatedStorageConfigDir.path;

    return _androidEmulatedStorageConfigDir.path.join(name);
  }

  String getPlatfromExternalConfigPath([String? name]) {
    if (Platform.isAndroid) {
      return getAndroidExternalConfigPath(name);
    }
    return getConfigPath(name);
  }

  /// ### Return -> [(count,size)]
  Future<(int, int)> getFolderInfo(Directory dir) async {
    if (!dir.existsSync()) return (0, 0);
    return await Isolate.run<(int, int)>(() {
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
        debugPrint('[AppUtils:deleteDir]: $e');
        return (0, 0);
      }
    });
  }

  Future<bool> deleteFolder(Directory dir) async {
    if (!dir.existsSync()) return false;
    return await Isolate.run(() {
      try {
        for (var file in dir.listSync()) {
          file.deleteSync(recursive: true);
        }
        return true;
      } catch (e) {
        debugPrint('[AppUtils:deleteDir]: $e');
        return false;
      }
    });
  }
}
