import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/config_widget/pdf_reader_prefer_theme_mode_chooser.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class PdfReaderSettingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<PdfReaderSettingPage> createState() => _PdfReaderSettingPageState();
}

class _PdfReaderSettingPageState extends State<PdfReaderSettingPage> {
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Reader Setting')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              PdfReaderPreferThemeModeChooser(),
              _infoDialogMenu,
              _preferReaderScrollbarEnable,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _infoDialogMenu {
    return StreamBuilder(
      stream: AppUtil.instance.config.stream.put.where(
        (e) => e.key == appReaderInfoDialogKey,
      ),
      builder: (context, asyncSnapshot) {
        final enable = AppUtil.instance.config.getBool(appReaderInfoDialogKey);
        return SwitchListTile.adaptive(
          tileColor: col.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          title: Text('Show Info in Dialog'),
          subtitle: Text('Show info in a dialog when available.'),
          value: enable,
          onChanged: (value) {
            AppUtil.instance.config.putAndWriteAll(
              appReaderInfoDialogKey,
              value,
            );
          },
        );
      },
    );
  }

  Widget get _preferReaderScrollbarEnable {
    return StreamBuilder(
      stream: AppUtil.instance.config.stream.put.where(
        (e) => e.key == pdfReaderPreferScrollbarEnableKey,
      ),
      builder: (context, asyncSnapshot) {
        final enable = AppUtil.instance.config.getBool(
          pdfReaderPreferScrollbarEnableKey,
        );
        return SwitchListTile.adaptive(
          tileColor: col.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(15)),
          title: Text('Enable Reader Scrollbar'),
          subtitle: Text(
            'Enable the scrollbar when the PDF Reader is first opened.',
          ),
          value: enable,
          onChanged: (value) {
            AppUtil.instance.config.putAndWriteAll(
              pdfReaderPreferScrollbarEnableKey,
              value,
            );
          },
        );
      },
    );
  }
}
