import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/utils/path_scanner.dart';

class PdfScanner extends PathScanner {
  PdfScanner({required super.scanFolders});

  @override
  bool isExcluded(FileSystemEntity file, String name) {
    if (name == 'Android' || name == 'DCIM' || name == 'MIUI') {
      return true;
    }
    return false;
  }

  @override
  PathScannerTest onFileTest(FileSystemEntity file, String name) {
    if (name.endsWith('.pdf')) return .add;
    return .skip;
  }

  static Future<List<PdfFile>> getAll() async {
    final scanFolders = <String>[];
    if (Platform.isLinux) {
      try {
        scanFolders.add((await getApplicationDocumentsDirectory()).path);
        scanFolders.add((await getDownloadsDirectory())!.path);
      } catch (e) {
        debugPrint('[PdfScanner:getAll:linux]: $e');
      }
    }
    if (Platform.isAndroid) {
      scanFolders.add(ThanPkg.android.app.getAppExternalPath());
    }
    // print(scanFolders);
    return await Isolate.run(() async {
      final list = <PdfFile>[];
      final entries = await PdfScanner(scanFolders: scanFolders).scan();
      for (var entry in entries) {
        list.add(PdfFile.fromEntry(entry));
      }
      list.sortDate();
      // sort newest
      return list;
    });
  }
}
