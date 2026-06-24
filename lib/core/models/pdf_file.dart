// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';

class PdfFile {
  final String name;
  final String path;
  final int size;
  final DateTime date;
  const PdfFile({required this.name, required this.path, required this.date, required this.size});

  factory PdfFile.fromEntry(FileSystemEntity entry) {
    return PdfFile(
      name: entry.getName(),
      path: entry.path,
      size: entry.size,
      date: entry.modifiedDate,
    );
  }
}

extension PdfFileExtensions on List<PdfFile> {
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
}
