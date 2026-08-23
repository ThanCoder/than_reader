import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class AppVersionView extends StatefulWidget {
  const AppVersionView({super.key});

  @override
  State<AppVersionView> createState() => _AppVersionViewState();
}

class _AppVersionViewState extends State<AppVersionView> {
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: col.surfaceContainer,
      contentPadding: .symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Container(
        padding: .all(8),
        decoration: BoxDecoration(
          color: col.tertiaryContainer,
          borderRadius: .circular(15),
        ),
        child: Icon(Icons.info_outline, color: col.onSurface),
      ),
      title: Text(
        'Version: ${AppUtils.instance.versionName}',
        style: TextStyle(color: col.onSurface),
      ),
      subtitle: Text('Check for updates and view release notes'),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
      onTap: () {
        if (Platform.isLinux) {
          ThanPkgLinux.getInstance.launcher.launchUrl(
            'https://github.com/ThanCoder/than_reader/releases',
          );
        }
        if (Platform.isAndroid) {
          ThanPkgAndroid.getInstance.launchHandler.launchUrl(
            'https://github.com/ThanCoder/than_reader/releases',
          );
        }
      },
    );
  }
}
