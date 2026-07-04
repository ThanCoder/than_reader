import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/utils/utils.dart';

class PdfConfigPathManager extends StatefulWidget {
  const PdfConfigPathManager({super.key});

  static final pathFolderNotifier = ValueNotifier<String>('');
  static final enableNotifier = ValueNotifier<bool>(false);

  @override
  State<PdfConfigPathManager> createState() => _PdfConfigPathManagerState();
}

class _PdfConfigPathManagerState extends State<PdfConfigPathManager> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    try {
      String path = CFBStore.getInstance.getString(
        'app-pdf-config-custom-path',
      );
      if (path.isEmpty) {
        path = '${await ThanPkg.platform.getAppExternalPath()}';
        path = path.join('.${Utils().packageInfo.appName}').join('config');
      }
      if (PdfConfigPathManager.enableNotifier.value) {
        final folder = Directory(path);
        if (!folder.existsSync()) {
          folder.createSync(recursive: true);
        }
      }
      PdfConfigPathManager.pathFolderNotifier.value = path;
    } catch (e) {
      debugPrint('[_PdfConfigPathManagerState:init]: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: PdfConfigPathManager.enableNotifier,
      builder: (context, value, child) {
        return SwitchListTile.adaptive(
          value: value,
          title: Text(
            'Custom Pdf Config Folder',
            maxLines: 2,
            overflow: .ellipsis,
          ),
          subtitle: Text(
            'path: ${PdfConfigPathManager.pathFolderNotifier.value}',
            maxLines: 2,
            overflow: .ellipsis,
            style: TextStyle(fontSize: 12),
          ),
          onChanged: (value) {
            PdfConfigPathManager.enableNotifier.value = value;
            init();
          },
        );
      },
    );
  }
}
