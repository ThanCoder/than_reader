import 'dart:async';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/desktop/desktop_home.dart';
import 'package:than_reader/platforms/mobile/mobile_home.dart';

class PlatformAppSwitcher extends StatefulWidget {
  const PlatformAppSwitcher({super.key});

  @override
  State<PlatformAppSwitcher> createState() => _PlatformAppSwitcherState();
}

class _PlatformAppSwitcherState extends State<PlatformAppSwitcher> {
  final cf = AppUtil.instance.config;
  BoxConstraints? constraints;
  Timer? _saveTimer;

  void saveSize() {
    if (constraints == null) return;
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 3), () {
      cf
          .put(appWindowWidthKey, constraints?.maxWidth)
          .put(appWindowHeightKey, constraints?.maxHeight)
          .writeAll();

      debugPrint('Saved Window Size: ${constraints?.maxWidth}');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (TPlatform.isDesktop) {
      return LayoutBuilder(
        builder: (context, constraints) {
          this.constraints = constraints;
          saveSize();
          final isMobile = constraints.maxWidth < 500;
          if (isMobile) {
            return MobileHome();
          }
          return DesktopHome();
        },
      );
    }
    // final isMobile = constraints.maxWidth < 600;
    final isMobile = TPlatform.isMobile;
    if (isMobile) {
      return MobileHome();
    }
    return DesktopHome();
  }
}
