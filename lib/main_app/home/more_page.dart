import 'package:flutter/material.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/partials/app_theme_chooser.dart';
import 'package:than_reader/partials/cache_manager.dart';
import 'package:than_reader/partials/custompath_scanner_manager_widget.dart';
import 'package:than_reader/partials/pdf_config_path_manager.dart';
import 'package:than_reader/partials/version_info_widget.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("More Apps")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppThemeChooser(),
              Divider(),
              VersionInfoWidget(),
              Divider(),
              CacheManagerListTile(cacheDirPath: Utils().cachePath),
              CustompathScannerManagerWidget(),
              PdfConfigPathManager(),
            ],
          ),
        ),
      ),
    );
  }
}
