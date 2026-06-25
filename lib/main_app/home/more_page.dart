import 'package:flutter/material.dart';
import 'package:than_reader/core/partials/app_theme_chooser.dart';
import 'package:than_reader/core/partials/custompath_scanner_manager_widget.dart';
import 'package:than_reader/core/partials/version_info_widget.dart';

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
              CustompathScannerManagerWidget(),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
