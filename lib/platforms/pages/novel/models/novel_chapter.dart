import 'package:dual_store/dual_store.dart';

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
}

class NovelChapterAdapter extends IDuBinaryMetaAdapter<NovelChapter> {
  @override
  int get adapterId => 2;

  @override
  NovelChapter fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(NovelChapter value) {
    return value.toJson();
  }
}

class NovelChapter extends IDuModel {
  final String title;
  final ChapterLaguage lang;
  final double chapter;
  final DateTime date;

  NovelChapter({
    required this.title,
    required this.lang,
    required this.chapter,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'lang': lang.name,
      'chapter': chapter,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory NovelChapter.fromJson(Map<String, dynamic> json) {
    return NovelChapter(
      title: json['title'],
      lang: ChapterLaguage.values.firstWhere((e) => e.name == json['lang']),
      chapter: json['chapter'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }

  NovelChapter copyWith({
    String? title,
    ChapterLaguage? lang,
    double? chapter,
    DateTime? date,
  }) {
    return NovelChapter(
      title: title ?? this.title,
      lang: lang ?? this.lang,
      chapter: chapter ?? this.chapter,
      date: date ?? this.date,
    );
  }
}

extension NovelChapterX on List<NovelChapter> {
  void sortChapter({bool smToBg = true}) {
    sort((a, b) {
      if (smToBg) {
        return a.chapter.compareTo(b.chapter);
      } else {
        return b.chapter.compareTo(a.chapter);
      }
    });
  }
}
