part of 'novel_chapter.dart';

enum ChapterLaguage {
  myanmar,
  english,
  china;

  String get label {
    return switch (this) {
      myanmar => 'Myanmar',
      english => 'English',
      china => 'China',
    };
  }

  IconData get icon {
    return switch (this) {
      ChapterLaguage.myanmar => Icons.translate,
      ChapterLaguage.english => Icons.language,
      ChapterLaguage.china => Icons.translate,
    };
  }

  static ChapterLaguage fromVal(String val) =>
      values.firstWhere((e) => e.name == val, orElse: () => myanmar);
}
