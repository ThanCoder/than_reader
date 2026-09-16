import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader_setting_page.dart';
import 'package:than_reader/platforms/components/app_seeds_color_chooser.dart';
import 'package:than_reader/platforms/components/app_version_view.dart';
import 'package:than_reader/platforms/components/cache_cleaner.dart';
import 'package:than_reader/platforms/pages/dev_pages/dev_route_tile.dart';
import 'package:than_reader/platforms/pages/share_server/server_home_page.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: col.surface,
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
              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                leading: Icon(Icons.settings),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('PDF Reader Setting'),
                onTap: () {
                  context.pushMaterialPageRoute(
                    builder: (mainCtx) => PdfReaderSettingPage(),
                  );
                },
              ),

              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                leading: Icon(Icons.share_outlined),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Share Server'),
                onTap: () {
                  context.pushMaterialPageRoute(
                    builder: (mainCtx) => ServerHomePage(),
                  );
                },
              ),

              ListTile(
                tileColor: col.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                leading: Icon(Icons.storage_outlined),
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Info Store'),
                onTap: () {
                  context.pushMaterialPageRoute(
                    builder: (mainCtx) => ReaderInfoStorePage(),
                  );
                },
              ),
              DevRouteTile(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
