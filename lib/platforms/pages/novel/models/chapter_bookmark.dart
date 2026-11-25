import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class ChapterBookmark {
  final String title;
  final ChapterLaguage lang;
  final double chapter;

  const ChapterBookmark({
    required this.title,
    required this.lang,
    required this.chapter,
  });

  ChapterBookmark copyWith({
    String? title,
    ChapterLaguage? lang,
    double? chapter,
  }) {
    return ChapterBookmark(
      title: title ?? this.title,
      lang: lang ?? this.lang,
      chapter: chapter ?? this.chapter,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'lang': lang.name, 'chapter': chapter};
  }

  factory ChapterBookmark.fromJson(Map<String, dynamic> json) {
    return ChapterBookmark(
      title: json['title'],
      lang: ChapterLaguage.fromVal(json['lang']),
      chapter: json['chapter'],
    );
  }

  @override
  String toString() =>
      '''ChapterBookmark(title: $title, lang: $lang, chapter: $chapter)''';
}
