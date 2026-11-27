part of 'reader_file.dart';

enum ReaderFileType {
  pdf,
  // epub,
  unknown;

  String get label {
    if (this == pdf) return 'PDF';
    // if (this == epub) return 'EPUB';
    return 'Unknown';
  }

  String get extname {
    if (this == pdf) return 'pdf';
    return '';
  }

  static ReaderFileType fromValue(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => unknown);
  }

  static ReaderFileType fromPath(String path) {
    final ext = path.extension;
    return values.firstWhere((e) => e.name == ext, orElse: () => unknown);
  }
}
