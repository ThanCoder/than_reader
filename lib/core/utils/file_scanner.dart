import 'dart:io';
import 'dart:isolate';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_pkg_linux/core/utils/path_ext.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/file_config_id_generator.dart';
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

  static Future<List<ReaderFile>> scanAll() async {
    final scanFolders = <String>[];
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'];
      if (home != null) {
        scanFolders.add(home.join('Desktop'));
        scanFolders.add(home.join('Documents'));
        scanFolders.add(home.join('Downloads'));
        scanFolders.add(home.join('Music'));
        scanFolders.add(home.join('Pictures'));
        scanFolders.add(home.join('Videos'));
      }
    }
    if (Platform.isAndroid) {
      scanFolders.add(ThanPkg.android.app.getAppExternalPath());
    }

    // print(scanFolders);
    return await Isolate.run(() async {
      final list = <ReaderFile>[];
      final entries = await FileScanner(scanFolders: scanFolders).scan();
      for (var entry in entries) {
        final reader = ReaderFile(
          name: entry.name,
          path: entry.path,
          parentPath: entry.parent.path,
          date: entry.modifiedDate,
          size: entry.size,
          configId: FileConfigIdGenerator.generateSync(entry.path),
          type: FileType.fromPath(entry.path),
        );
        list.add(reader);
      }
      list.sortDate();
      // sort newest
      return list;
    });
  }
}
