// enum FileType { pdf, epub, mobi, txt, unknown }
import 'package:dart_core_extensions/dart_core_extensions.dart';

enum FileType {
  pdf,
  // epub,
  unknown;

  static FileType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => unknown);
  }

  static FileType fromPath(String path) {
    final ext = path.extension;
    return values.firstWhere((e) => e.name == ext, orElse: () => unknown);
  }
}

class ReaderFile {
  final String name;
  final String parentPath;
  final String path;
  final int size;
  final DateTime date;
  final String configId;
  final FileType type;
  const ReaderFile({
    required this.name,
    required this.path,
    required this.parentPath,
    required this.date,
    required this.size,
    required this.configId,
    required this.type,
  });
  ReaderFile copyWith({
    String? name,
    String? parentPath,
    String? path,
    int? size,
    DateTime? date,
    String? configId,
    FileType? type,
  }) {
    return ReaderFile(
      name: name ?? this.name,
      parentPath: parentPath ?? this.parentPath,
      path: path ?? this.path,
      size: size ?? this.size,
      date: date ?? this.date,
      configId: configId ?? this.configId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'parentPath': parentPath,
      'path': path,
      'size': size,
      'date': date.millisecondsSinceEpoch,
      'configId': configId,
      'type': type.name,
    };
  }

  factory ReaderFile.fromMap(Map<String, dynamic> map) {
    return ReaderFile(
      name: map['name'] as String,
      parentPath: map['parentPath'] as String,
      path: map['path'] as String,
      size: map['size'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      configId: map['configId'] as String,
      type: FileType.fromValue(map.getString(['type'])),
    );
  }
}

extension AppFileExtensions on List<ReaderFile> {
  void sortA2Z({bool a2z = true}) {
    sort((a, b) {
      if (a2z) {
        return a.name.compareTo(b.name);
      } else {
        return b.name.compareTo(a.name);
      }
    });
  }

  void sortDate({bool new2old = true}) {
    sort((a, b) {
      if (new2old) {
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

  void sortSize({bool small2big = true}) {
    sort((a, b) {
      if (small2big) {
        return a.size.compareTo(b.size);
      } else {
        return b.size.compareTo(a.size);
      }
    });
  }
}
