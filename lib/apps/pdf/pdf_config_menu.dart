import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/apps/pdf/pdf_reader.dart';
import 'package:than_reader/apps/pdf/reader_theme_mode.dart';
import 'package:than_reader/apps/pdf/screen_orientation.dart';

class PdfConfigMenu extends StatefulWidget {
  const PdfConfigMenu({super.key, required this.config});

  final PdfConfig config;

  @override
  State<PdfConfigMenu> createState() => _PdfConfigMenuState();
}

class _PdfConfigMenuState extends State<PdfConfigMenu> {
  late PdfConfig config;
  final CFBStore cf = PdfReader.cf;
  @override
  void initState() {
    config = widget.config;
    super.initState();
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  final orientations = ScreenOrientation.values;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop<PdfConfig>(context, config);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          spacing: 4,
          children: [
            //Platform Config
            _platformConfig(),
            Divider(),
            // android only
            _androidOnly(),

            Divider(),
            _allReaderConfig(),
          ],
        ),
      ),
    );
  }

  Widget _platformConfig() {
    return Container(
      padding: .symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: col.surface,
        borderRadius: .circular(15),
      ),
      child: Material(
        color: col.surface,
        child: Column(
          spacing: 4,
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Platform Config',
                style: TextStyle(
                  fontWeight: .w700,
                  fontSize: 17,
                  color: col.onSurface,
                ),
              ),
            ),

            SwitchListTile.adaptive(
              tileColor: col.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              title: Text('Full screen'),
              subtitle: Text('Reader Fullscreen'),
              value: config.isFullscreen,
              onChanged: (value) {
                config = config.copyWith(isFullscreen: value);
                setState(() {});
              },
            ),
            SwitchListTile.adaptive(
              tileColor: col.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              title: Text(
                'Scrollbar',
                style: TextStyle(color: col.onSurface, fontWeight: .w600),
              ),
              subtitle: Text(
                'Reader Scrollbar Enable or Disable',
                style: TextStyle(
                  color: col.onSurfaceVariant,
                  fontWeight: .w400,
                ),
              ),
              value: config.scrollbarEnable,
              onChanged: (value) {
                config = config.copyWith(scrollbarEnable: value);
                setState(() {});
              },
            ),
            _readerThemeMode(),
          ],
        ),
      ),
    );
  }

  final readerModes = ReaderThemeMode.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.label)))
      .toList();

  ListTile _readerThemeMode() => ListTile(
    tileColor: col.surfaceContainer,
    shape: RoundedRectangleBorder(borderRadius: .circular(15)),
    // leading: Icon(Icons.color_lens_outlined),
    title: Text('Reader Theme Mode'),
    subtitle: Text('Theme Appy Mode'),
    trailing: DropdownButtonHideUnderline(
      child: DropdownButton<ReaderThemeMode>(
        dropdownColor: col.surfaceContainer,
        style: TextStyle(fontWeight: .w600, color: col.onSurface),
        padding: .symmetric(vertical: 8, horizontal: 10),
        borderRadius: .circular(15),
        value: config.readerThemeMode,
        items: readerModes,
        onChanged: (value) {
          config = config.copyWith(readerThemeMode: value);
          setState(() {});
        },
      ),
    ),
  );

  Widget _allReaderConfig() {
    return StreamBuilder(
      stream: cf.stream.put,
      builder: (context, asyncSnapshot) {
        return Container(
          padding: .symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: col.surface,
            borderRadius: .circular(15),
          ),
          child: Material(
            color: col.surface,
            child: Column(
              spacing: 4,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Reader Config Label',
                    style: TextStyle(
                      fontWeight: .w700,
                      fontSize: 17,
                      color: col.onSurface,
                    ),
                  ),
                ),
                _switchMenu(
                  title: '(Dark | Light) Button',
                  subtitle: 'show button enable',
                  value: PdfReader.isEnable(PdfReader.darkModeEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.darkModeEnableKey, value);
                  },
                ),
                _switchMenu(
                  title: 'FullScreen Button',
                  subtitle: 'show button enable',
                  value: PdfReader.isEnable(PdfReader.fullscreenEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.fullscreenEnableKey, value);
                  },
                ),
                _switchMenu(
                  title: 'Zoom In Button',
                  subtitle: 'show button enable',
                  value: PdfReader.isEnable(PdfReader.zoomInEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.zoomInEnableKey, value);
                  },
                ),
                _switchMenu(
                  title: 'Zoom Out Button',
                  subtitle: 'show button enable',
                  value: PdfReader.isEnable(PdfReader.zoomOutEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.zoomOutEnableKey, value);
                  },
                ),
                _switchMenu(
                  title: 'Zoom Lable',
                  subtitle: 'show Label enable',
                  value: PdfReader.isEnable(PdfReader.zoomLableEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.zoomLableEnableKey, value);
                  },
                ),
                _switchMenu(
                  title: 'Scrollbar Button',
                  subtitle: 'show button enable',
                  value: PdfReader.isEnable(PdfReader.scrollbarEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.scrollbarEnableKey, value);
                  },
                ),

                _switchMenu(
                  title: 'Cache Label',
                  subtitle: 'show label enable',
                  value: PdfReader.isEnable(PdfReader.cacheLableEnableKey),
                  onChanged: (value) {
                    PdfReader.put(PdfReader.cacheLableEnableKey, value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _androidOnly() {
    return Container(
      padding: .symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: col.surface,
        borderRadius: .circular(15),
      ),
      child: Material(
        color: col.surface,
        child: Column(
          spacing: 4,
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Android Only',
                style: TextStyle(
                  fontWeight: .w700,
                  fontSize: 17,
                  color: col.onSurface,
                ),
              ),
            ),
            SwitchListTile.adaptive(
              tileColor: col.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              title: Text(
                'Keep Screen',
                style: TextStyle(color: col.onSurface, fontWeight: .w600),
              ),
              subtitle: Text(
                'It Work Android!',
                style: TextStyle(
                  color: col.onSurfaceVariant,
                  fontWeight: .w400,
                ),
              ),
              value: config.isKeepScreen,
              onChanged: (value) {
                config = config.copyWith(isKeepScreen: value);
                setState(() {});
              },
            ),

            _orientation(),
          ],
        ),
      ),
    );
  }

  ListTile _orientation() {
    final items = orientations
        .map(
          (e) => DropdownMenuItem<ScreenOrientation>(
            value: e,
            child: Text(e.label),
          ),
        )
        .toList();
    return ListTile(
      tileColor: col.surfaceContainer,
      titleTextStyle: TextStyle(color: col.onSurface, fontWeight: .w600),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      title: Text('Screen Orientation'),
      subtitle: Text('Only Work in Android!'),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<ScreenOrientation>(
          borderRadius: .circular(15),
          dropdownColor: col.surfaceContainerLow,
          value: config.orientation,
          items: items,
          onChanged: (value) {
            config = config.copyWith(orientation: value);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _switchMenu({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool value)? onChanged,
  }) {
    return SwitchListTile.adaptive(
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      title: Text(
        title,
        style: TextStyle(color: col.onSurface, fontWeight: .w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: col.onSurfaceVariant, fontWeight: .w400),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
