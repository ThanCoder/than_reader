import 'package:dart_core_extensions/dart_core_extensions.dart';

class PdfConfigBookmark {
  final int page;
  final String title;
  const PdfConfigBookmark({required this.page, required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'page': page, 'title': title};
  }

  factory PdfConfigBookmark.fromMap(Map<String, dynamic> map) {
    return PdfConfigBookmark(
      page: map.getInt(['page']),
      title: map.getString(['title']),
    );
  }

  @override
  String toString() => 'PdfConfigBookmark(page: $page, title: $title)';
}

extension PdfConfigBookmarkExt on List<PdfConfigBookmark> {
  void sortPageNumber({bool sm2big = true}) {
    sort((a, b) {
      return a.page.compareTo(b.page);
    });
  }
}
