import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/platforms/desktop/desktop_home.dart';
import 'package:than_reader/platforms/mobile/mobile_home.dart';

class PlatformAppSwitcher extends StatelessWidget {
  const PlatformAppSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    // final isMobile = constraints.maxWidth < 600;
    final isMobile = TPlatform.isMobile;
    if (isMobile) {
      return MobileHome();
    }
    return DesktopHome();
  }
}
