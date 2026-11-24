part of 'chapter_content_replacer.dart';

class ChapterContentReplacerText extends IChapterContentReplacer {
  @override
  final String id;
  @override
  final bool enable;
  final String matchText;
  final String toText;

  const new({
    required this.id,
    required this.matchText,
    required this.toText,
    required this.enable,
  });

  @override
  String apply(String text) {
    if (!enable) return text;

    try {
      return text.replaceAll(RegExp(matchText, multiLine: true), toText).trim();
    } on FormatException {
      return text;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'enable': enable,
      'matchText': matchText,
      'toText': toText,
    };
  }

  factory ChapterContentReplacerText.fromJson(Map<String, dynamic> json) {
    return ChapterContentReplacerText(
      id: json['id'],
      enable: json['enable'],
      matchText: json['matchText'],
      toText: json['toText'],
    );
  }

  ChapterContentReplacerText copyWith({
    String? id,
    bool? enable,
    String? matchText,
    String? toText,
  }) {
    return ChapterContentReplacerText(
      id: id ?? this.id,
      enable: enable ?? this.enable,
      matchText: matchText ?? this.matchText,
      toText: toText ?? this.toText,
    );
  }

  @override
  String toString() {
    return '''ChapterContentReplacerText(id: $id, enable: $enable, matchText: $matchText, toText: $toText)''';
  }
}
