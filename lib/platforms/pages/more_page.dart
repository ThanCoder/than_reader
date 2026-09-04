import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader_prefer_theme_mode_chooser.dart';
import 'package:than_reader/platforms/components/app_seeds_color_chooser.dart';
import 'package:than_reader/platforms/components/app_version_view.dart';
import 'package:than_reader/platforms/components/cache_cleaner.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(title: Text('More')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 5,
            children: [
              TMaterialThemeProviderChooser(),
              AppVersionView(),
              AppSeedsColorChooser(),
              CacheCleaner(key: UniqueKey()),
              // ReaderTrackerListTile(),
              PdfReaderPreferThemeModeChooser(),
            ],
          ),
        ),
      ),
    );
  }
}
