part of 'chapter_content_replacer.dart';

class ChapterContentReplacerLine extends IChapterContentReplacer {
  @override
  final String id;
  final int start;
  final int line;
  final String toText;

  const ChapterContentReplacerLine({
    required this.id,
    required this.start,
    required this.line,
    required this.toText,
  });

  @override
  String apply(String text) {
    final lines = text.split('\n');

    final normalizedStart = start < 0 ? lines.length + start : start;

    final normalizedEnd = line == -1 ? lines.length : normalizedStart + line;

    if (line < -1 ||
        normalizedStart < 0 ||
        normalizedStart > lines.length ||
        normalizedEnd > lines.length ||
        normalizedEnd < normalizedStart) {
      return text;
    }

    lines.replaceRange(normalizedStart, normalizedEnd, [toText]);

    return lines.join('\n');
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'start': start, 'line': line, 'toText': toText};
  }

  factory ChapterContentReplacerLine.fromJson(Map<String, dynamic> json) {
    return ChapterContentReplacerLine(
      id: json['id'],
      start: json['start'],
      line: json['line'],
      toText: json['toText'],
    );
  }

  ChapterContentReplacerLine copyWith({
    String? id,
    int? start,
    int? line,
    String? toText,
  }) {
    return ChapterContentReplacerLine(
      id: id ?? this.id,
      start: start ?? this.start,
      line: line ?? this.line,
      toText: toText ?? this.toText,
    );
  }

  @override
  String toString() {
    return '''ChapterContentReplacerLine(id: $id, start: $start, line: $line, toText: $toText)''';
  }
}
