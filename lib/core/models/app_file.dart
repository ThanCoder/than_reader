// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'package:than_reader/core/utils/file_config_id_generator.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/partials/pdf_config_path_manager.dart';

// enum FileType { pdf, epub, mobi, txt, unknown }
enum FileType { pdf, epub, unknown }

class AppFile {
  final String name;
  final String path;
  final int size;
  final DateTime date;
  final String configId;
  final FileType type;
  const AppFile({
    required this.name,
    required this.path,
    required this.date,
    required this.size,
    required this.configId,
    required this.type,
  });

  factory AppFile.fromEntry(FileSystemEntity entry) {
    return AppFile(
      name: entry.getName(),
      path: entry.path,
      size: entry.size,
      date: entry.modifiedDate,
      configId: FileConfigIdGenerator.generateSync(entry.path),
      type: _getFileType(entry.path),
    );
  }
  factory AppFile.fromFile(File file) {
    return AppFile(
      name: file.getName(),
      path: file.path,
      size: file.size,
      date: file.modifiedDate,
      configId: FileConfigIdGenerator.generateSync(file.path),
      type: _getFileType(file.path),
    );
  }

  // Path ကနေပြီး file extension ကို ရှာပြီး FileType သတ်မှတ်ပေးမယ့် helper method
  static FileType _getFileType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return FileType.pdf;
      case 'epub':
        return FileType.epub;
      // case 'mobi':
      //   return FileType.mobi;
      // case 'txt':
      //   return FileType.txt;
      default:
        return FileType.unknown;
    }
  }

  String get configPath {
    if (PdfConfigPathManager.enableNotifier.value) {
      return PdfConfigPathManager.pathFolderNotifier.value.join(
        '$configId-config',
      );
    }
    return Utils.instance.getConfigPath('$configId-config');
  }

  AppFile copyWith({
    String? name,
    String? path,
    int? size,
    DateTime? date,
    String? configId,
    FileType? type,
  }) {
    return AppFile(
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      date: date ?? this.date,
      configId: configId ?? this.configId,
      type: type ?? this.type,
    );
  }
}

extension AppFileExtensions on List<AppFile> {
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


