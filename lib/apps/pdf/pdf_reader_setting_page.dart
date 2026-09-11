import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/pdf_reader_prefer_theme_mode_chooser.dart';

class PdfReaderSettingPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('PDF Reader Setting'),),body: Column(children: [
      PdfReaderPreferThemeModeChooser(),
    ],),);
  }
}