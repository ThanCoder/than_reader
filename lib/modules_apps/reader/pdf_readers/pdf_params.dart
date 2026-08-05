import 'package:dart_core_extensions/dart_core_extensions.dart';

enum PdfThemeMode {
  systemFollow,
  appFollow,
  light,
  dark;

  static PdfThemeMode fromName(String name) {
    return values.firstWhere((e) => e.name == name, orElse: () => .appFollow);
  }
}

enum PdfReaderType {
  autoReader,
  thanPdfReader,
  pdfrxReader;

  String get label {
    return switch (this) {
      .thanPdfReader => 'Than Reader',
      .pdfrxReader => 'PdfRx Reader',
      _ => 'Auto Choose Reader',
    };
  }

  static PdfReaderType fromName(String name) {
    return values.firstWhere((e) => e.name == name, orElse: () => .autoReader);
  }
}

class PdfBookmark {
  final int page;
  final String title;
  PdfBookmark({required this.page, required this.title});

  PdfBookmark copyWith({int? page, String? title}) {
    return PdfBookmark(page: page ?? this.page, title: title ?? this.title);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'page': page, 'title': title};
  }

  factory PdfBookmark.fromMap(Map<String, dynamic> map) {
    return PdfBookmark(
      page: map.getInt(['page']),
      title: map.getString(['title'], def: 'Untitled'),
    );
  }
}
