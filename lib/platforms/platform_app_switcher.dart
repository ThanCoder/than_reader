import 'package:flutter/material.dart';
import 'package:than_reader/platforms/desktop/desktop_home.dart';
import 'package:than_reader/platforms/mobile/mobile_home.dart';

class PlatformAppSwitcher extends StatelessWidget {
  const PlatformAppSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 400;
        if (isMobile) {
          return MobileHome();
        }
        return DesktopHome();
      },
    );
  }
}
