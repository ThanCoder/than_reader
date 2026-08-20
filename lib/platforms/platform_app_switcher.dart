import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_reader/platforms/desktop/desktop_home.dart';
import 'package:than_reader/platforms/mobile/mobile_home.dart';

class PlatformAppSwitcher extends StatelessWidget {
  const PlatformAppSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return MobileHome();
    }
    return DesktopHome();
  }
}
