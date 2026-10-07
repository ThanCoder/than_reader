import 'dart:io';
import 'dart:isolate';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/path_scanner.dart';
import 'package:than_reader/core/utils/platform_util.dart';
import 'package:than_reader/platforms/pages/novel/novel_file.dart';

class NovelFileScanner extends PathScanner {
  new({required super.scanFolders});

  @override
  PathScannerTest onFileTest(FileSystemEntity file, String name) {
    if (name.endsWith('.$novelExtName')) return .add;
    return .skip;
  }

  static Future<List<NovelFile>> scanAll() async {
    final scanFolders = PlatformUtil.getPlatformScanFolders();

    // print(scanFolders);
    return await Isolate.run(() async {
      final list = <NovelFile>[];
      final entries = await NovelFileScanner(scanFolders: scanFolders).scan();
      for (var entry in entries) {
        list.add(
          .new(
            name: entry.onlyName,
            path: entry.path,
            ext: entry.extName,
            size: entry.size,
            date: entry.modifiedDate,
          ),
        );
      }
      // list.sortDate();
      // sort newest
      return list;
    });
  }
}
