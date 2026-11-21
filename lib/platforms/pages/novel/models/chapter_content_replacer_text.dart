part of 'chapter_content_replacer.dart';

class ChapterContentReplacerText extends IChapterContentReplacer {
  @override
  final String id;
  final String matchText;
  final String toText;

  const new({required this.id, required this.matchText, required this.toText});

  @override
  String apply(String text) {
    return text.replaceAll(matchText, toText);
  }

  ChapterContentReplacerText copyWith({
    String? id,
    String? matchText,
    String? toText,
  }) {
    return ChapterContentReplacerText(
      id: id ?? this.id,
      matchText: matchText ?? this.matchText,
      toText: toText ?? this.toText,
    );
  }

  factory ChapterContentReplacerText.fromJson(Map<String, dynamic> json) {
    return ChapterContentReplacerText(
      id: json['id'],
      matchText: json['matchText'],
      toText: json['toText'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'matchText': matchText, 'toText': toText};
  }
}
