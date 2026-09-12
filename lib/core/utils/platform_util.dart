import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

class PlatformUtil {
  static Future<void> launchUrl(String url) async {
    if (Platform.isLinux) {
      await ThanPkgLinux.getInstance.launcher.launchUrl(url);
      return;
    }
    if (Platform.isAndroid) {
      await ThanPkgAndroid.getInstance.launchHandler.launchUrl(url);
      return;
    }
  }

  static Future<String> getOutPath(String name) async {
    if (Platform.isLinux) {
      final p = await ThanPkgLinux.getInstance.pathHandler
          .getDownloadsDirectory();
      return p!.join(name);
    }
    if (Platform.isAndroid) {
      return ThanPkgAndroid.getInstance.pathHandler.getDownloadPath().join(
        name,
      );
    }

    throw UnsupportedError('Only Supported -> `android`,`linux`');
  }
}
