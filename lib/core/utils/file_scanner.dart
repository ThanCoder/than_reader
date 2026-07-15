import 'dart:io';
import 'dart:isolate';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/partials/custompath_scanner_manager_widget.dart';
import 'package:than_reader/core/utils/path_scanner.dart';

class FileScanner extends PathScanner {
  FileScanner({required super.scanFolders});

  @override
  bool isExcluded(FileSystemEntity file, String name) {
    if (name == 'Android' || name == 'DCIM' || name == 'MIUI') {
      return true;
    }
    return false;
  }

  @override
  PathScannerTest onFileTest(FileSystemEntity file, String name) {
    final ext = name.extName;

    // if (name.endsWith('.pdf')) return .add;
    if (FileType.values.map((e) => e.name).contains(ext)) return .add;
    return .skip;
  }

  static Future<List<AppFile>> getAll() async {
    final scanFolders = <String>[];
    if (Platform.isLinux) {
      try {
        scanFolders.add((await getApplicationDocumentsDirectory()).path);
        scanFolders.add((await getDownloadsDirectory())!.path);
        final homePath = Platform.environment['HOME'];
        if (homePath != null) {
          scanFolders.add(homePath.join('Desktop'));
        }
      } catch (e) {
        debugPrint('[FileScanner:getAll:linux]: $e');
      }
    }
    if (Platform.isAndroid) {
      scanFolders.add(ThanPkg.android.app.getAppExternalPath());
    }
    // custom scan path
    final customPathList = CustompathScannerManagerWidget.customPathList
        .toList();
    if (customPathList.isNotEmpty) {
      scanFolders.addAll(customPathList);
    }

    // print(scanFolders);
    return await Isolate.run(() async {
      final list = <AppFile>[];
      final entries = await FileScanner(scanFolders: scanFolders).scan();
      for (var entry in entries) {
        list.add(AppFile.fromEntry(entry));
      }
      list.sortDate();
      // sort newest
      return list;
    });
  }
}
