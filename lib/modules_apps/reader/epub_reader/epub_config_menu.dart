import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_config.dart';

class EpubConfigMenu extends StatefulWidget {
  final EpubConfig config;
  const EpubConfigMenu({super.key, required this.config});

  @override
  State<EpubConfigMenu> createState() => _EpubConfigMenuState();
}

class _EpubConfigMenuState extends State<EpubConfigMenu> {
  late EpubConfig config;
  @override
  void initState() {
    config = widget.config;
    super.initState();
    init();
  }

  void init() {
    if (config.fontSize != -1) {
      useFontSize = true;
    }
    if (config.fontFamily.isNotEmpty) {
      useFontFamily = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop<EpubConfig>(context, config);
      },
      child: SingleChildScrollView(
        child: Column(
          spacing: 5,

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Config Setting',
                style: TextStyle(fontSize: 20, fontWeight: .bold),
              ),
            ),
            Divider(),

            fontWidget,
            fontFamilyWidget,

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  bool useFontSize = false;

  Widget get fontWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Checkbox.adaptive(
            value: useFontSize,
            onChanged: (value) {
              useFontSize = value!;
              if (!useFontSize) {
                config = config.copyWith(fontSize: -1);
              }
              setState(() {});
            },
          ),
          Text('Custom Font Size'),
          Spacer(),
          TFontListWiget(
            fontSize: config.fontSize != -1 ? config.fontSize.toInt() : 17,
            onChange: (fontSize) {
              config = config.copyWith(fontSize: fontSize.toDouble());
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  bool useFontFamily = false;
  List<String> fontFamilyList = ['-1', 'Winnwa', 'Zawgyi-One-V3.1'];

  Widget get fontFamilyWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text("App Font Family"),
          Spacer(),
          DropdownButton<String>(
            value: config.fontFamily,
            items: fontFamilyList
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e == '-1' ? 'None' : e),
                  ),
                )
                .toList(),
            onChanged: (value) {
              config = config.copyWith(fontFamily: value!);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
