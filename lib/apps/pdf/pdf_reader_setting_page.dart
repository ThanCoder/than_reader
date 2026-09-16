import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/pdf_reader_prefer_theme_mode_chooser.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class PdfReaderSettingPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('PDF Reader Setting')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              PdfReaderPreferThemeModeChooser(),
              StreamBuilder(
                stream: AppUtils.instance.config.stream.put.where(
                  (e) => e.key == appReaderInfoDialogKey,
                ),
                builder: (context, asyncSnapshot) {
                  final enable = AppUtils.instance.config.getBool(
                    appReaderInfoDialogKey,
                  );
                  return SwitchListTile.adaptive(
                    tileColor: col.surfaceContainer,
                    shape: RoundedRectangleBorder(borderRadius: .circular(15)),
                    title: Text('Info Dialog Menu'),
                    subtitle: Text('Info ရှိနေရင် Dialog နဲ့ပြပေးမယ်'),
                    value: enable,
                    onChanged: (value) {
                      AppUtils.instance.config.putAndWriteAll(
                        appReaderInfoDialogKey,
                        value,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
