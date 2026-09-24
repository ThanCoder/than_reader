import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/reader_theme_mode.dart';
import 'package:than_reader/const_keys.dart';

class PdfReaderPreferThemeModeChooser extends StatefulWidget {
  const PdfReaderPreferThemeModeChooser({super.key});

  @override
  State<PdfReaderPreferThemeModeChooser> createState() =>
      _PdfReaderPreferThemeModeChooserState();

  static final currentNotifier = ValueNotifier<ReaderThemeMode>(
    .followAppTheme,
  );

  static final _cf = CFBStore.instance;

  static void init() {
    currentNotifier.value = .fromValue(
      _cf.getString(pdfReaderPreferThemeModeChooserKey),
    );
  }

  static void setMode(ReaderThemeMode mode) {
    currentNotifier.value = mode;
    _cf.putAndWriteAll(pdfReaderPreferThemeModeChooserKey, mode.name);
  }
}

class _PdfReaderPreferThemeModeChooserState
    extends State<PdfReaderPreferThemeModeChooser> {
  ColorScheme get col => Theme.of(context).colorScheme;

  final items = ReaderThemeMode.values
      .map(
        (e) =>
            DropdownMenuItem<ReaderThemeMode>(value: e, child: Text(e.label)),
      )
      .toList();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: .symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      tileColor: col.surfaceContainer,
      title: Text(
        'PDF Reader Theme Mode',
        style: TextStyle(fontSize: 16, fontWeight: .w600, color: col.onSurface),
      ),
      subtitle: Text(
        'Automatically selects the appropriate theme while reading PDFs.',
        style: TextStyle(
          fontSize: 12,
          fontWeight: .w400,
          color: col.onSurfaceVariant,
        ),
      ),
      trailing: DropdownButtonHideUnderline(
        child: ValueListenableBuilder(
          valueListenable: PdfReaderPreferThemeModeChooser.currentNotifier,
          builder: (context, value, child) {
            return DropdownButton<ReaderThemeMode>(
              borderRadius: .circular(15),
              dropdownColor: col.surfaceContainerHigh,
              style: TextStyle(fontSize: 12, color: col.onSurface),
              value: value,
              items: items,
              onChanged: (val) {
                PdfReaderPreferThemeModeChooser.setMode(val!);
              },
            );
          },
        ),
      ),
    );
  }
}
