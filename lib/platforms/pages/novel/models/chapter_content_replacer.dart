class ChapterContentReplacer {
  const ChapterContentReplacer({
    required this.id,
    required this.matchText,
    required this.toText,
  });
  final String id;
  final String matchText;
  final String toText;

  String apply(String text) {
    return text.replaceAll(matchText, toText);
  }

  ChapterContentReplacer copyWith({
    String? id,
    String? matchText,
    String? toText,
  }) {
    return ChapterContentReplacer(
      id: id ?? this.id,
      matchText: matchText ?? this.matchText,
      toText: toText ?? this.toText,
    );
  }

  factory ChapterContentReplacer.fromJson(Map<String, dynamic> json) {
    return ChapterContentReplacer(
      id: json['id'],
      matchText: json['matchText'],
      toText: json['toText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'matchText': matchText, 'toText': toText};
  }
}
