part 'chapter_content_replacer_number.dart';
part 'chapter_content_replacer_text.dart';

sealed class IChapterContentReplacer {
  const IChapterContentReplacer();
  String apply(String text);
  Map<String, dynamic> toJson();
  String get id;

  bool get isLineMatcher => this is ChapterContentReplacerLine;
  bool get isTexMatcher => this is ChapterContentReplacerText;
}
