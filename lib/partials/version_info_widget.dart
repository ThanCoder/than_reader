import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:than_pkg/than_pkg.dart';

class VersionInfoWidget extends StatelessWidget {
  const VersionInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null) {
          return SizedBox.shrink();
        }
        return ListTile(
          leading: Icon(Icons.info_rounded),
          title: Text("Version: ${info.version}-${info.buildNumber}"),
          onTap: () {
            ThanPkg.platform.launch(
              'https://github.com/ThanCoder/than_reader/releases',
            );
          },
        );
      },
    );
  }
}
