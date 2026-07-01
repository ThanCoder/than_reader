// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/core/utils/utils.dart';

class PdfFile {
  final String name;
  final String path;
  final int size;
  final DateTime date;
  const PdfFile({
    required this.name,
    required this.path,
    required this.date,
    required this.size,
  });

  factory PdfFile.fromEntry(FileSystemEntity entry) {
    return PdfFile(
      name: entry.getName(),
      path: entry.path,
      size: entry.size,
      date: entry.modifiedDate,
    );
  }
  factory PdfFile.fromFile(File file) {
    return PdfFile(
      name: file.getName(),
      path: file.path,
      size: file.size,
      date: file.modifiedDate,
    );
  }
  String get configPath => Utils.instance.getConfigPath(
    '${path.getName(withExt: false)}-config.json',
  );
}

extension PdfFileExtensions on List<PdfFile> {
  void sortA2Z({bool isA2Z = true}) {
    sort((a, b) {
      if (isA2Z) {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });
  }

  void sortDate({bool isNewest = true}) {
    sort((a, b) {
      if (isNewest) {
        return b.date.millisecondsSinceEpoch.compareTo(
          a.date.millisecondsSinceEpoch,
        );
      } else {
        return a.date.millisecondsSinceEpoch.compareTo(
          b.date.millisecondsSinceEpoch,
        );
      }
    });
  }

  void sortSize({bool isSmallest = true}) {
    sort((a, b) {
      if (isSmallest) {
        return a.size.compareTo(b.size);
      } else {
        return b.size.compareTo(a.size);
      }
    });
  }
}
