import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/utils/path_scanner.dart';

class PdfScanner extends PathScanner {
  PdfScanner({required super.scanFolders});

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
