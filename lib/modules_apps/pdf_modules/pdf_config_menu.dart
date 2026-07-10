import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';

class PdfConfigMenu extends StatefulWidget {
  final PdfConfig config;
  const PdfConfigMenu({super.key, required this.config});

  @override
  State<PdfConfigMenu> createState() => _PdfConfigMenuState();
}

class _PdfConfigMenuState extends State<PdfConfigMenu> {
  late PdfConfig config;
  final scrollByArrowKeyController = TextEditingController();
  final scrollByMouseWheelController = TextEditingController();
  final orientationList = ScreenOrientationTypes.values;
  final pdfThemeList = PdfThemeMode.values;

  @override
  void initState() {
    config = widget.config;
    scrollByArrowKeyController.text = config.scrollByArrowKey.toString();
    scrollByMouseWheelController.text = config.scrollByMouseWheel.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop<PdfConfig>(config);
      },
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile.adaptive(
                  title: Text('isKeepScreen'),
                  value: config.isKeepScreen,
                  onChanged: (value) {
                    config = config.copyWith(isKeepScreen: value);
                    setState(() {});
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text('FullScreen'),
                  value: config.isFullscreen,
                  onChanged: (value) {
                    config = config.copyWith(isFullscreen: value);
                    setState(() {});
                  },
                ),
                themeChooser,
                if (Platform.isAndroid) orientationChooser,
                TTextField(
                  label: Text('ScrollByArrowKey'),
                  maxLines: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  controller: scrollByArrowKeyController,
                ),
                TTextField(
                  label: Text('ScrollByMouseWheel'),
                  maxLines: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputType: TextInputType.number,
                  controller: scrollByMouseWheelController,
                ),
                SizedBox(height: 20),
                Divider(),
                actions,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get themeChooser {
    return DropdownButton(
      padding: EdgeInsets.all(5),
      hint: Text('PDF Theme Modes'),
      value: config.themeMode,
      items: pdfThemeList
          .map(
            (e) => DropdownMenuItem(value: e, child: Text(e.name.toCaptalize)),
          )
          .toList(),
      onChanged: (value) {
        config = config.copyWith(themeMode: value);
        setState(() {});
      },
    );
  }

  Widget get orientationChooser {
    return DropdownButton(
      padding: EdgeInsets.all(5),
      hint: Text('Orientation'),
      value: config.screenOrientationTypes,
      items: orientationList
          .map(
            (e) => DropdownMenuItem(value: e, child: Text(e.name.toCaptalize)),
          )
          .toList(),
      onChanged: (value) {
        config = config.copyWith(screenOrientationTypes: value);
        setState(() {});
      },
    );
  }

  Widget get actions {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop<PdfConfig>(config);
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
