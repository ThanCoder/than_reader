import 'package:dual_store/dual_store.dart';

class NovelDescAdapter extends IDuBinaryMetaAdapter<NovelDesc> {
  @override
  int get adapterId => 1;

  @override
  NovelDesc fromMap(Map<String, dynamic> map) {
    return .fromJson(map);
  }

  @override
  Map<String, dynamic> toMap(NovelDesc value) {
    return value.toJson();
  }
}

class NovelDesc extends IDuModel {
  final String title;
  final String author;
  final String translator;
  final String mc;
  final String desc;
  final List<String> urls;
  final List<String> tags;

  NovelDesc({
    required this.title,
    required this.author,
    required this.translator,
    required this.mc,
    required this.desc,
    required this.urls,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'translator': translator,
      'mc': mc,
      'desc': desc,
      'urls': urls,
      'tags': tags,
    };
  }

  factory NovelDesc.fromJson(Map<String, dynamic> json) {
    return NovelDesc(
      title: json['title'],
      author: json['author'],
      translator: json['translator'],
      mc: json['mc'],
      desc: json['desc'],
      urls: List<String>.from(json['urls']),
      tags: List<String>.from(json['tags']),
    );
  }

  @override
  String toString() {
    return '''NovelDesc(title: $title, author: $author, translator: $translator, mc: $mc, desc: $desc, urls: $urls, tags: $tags)''';
  }

  factory NovelDesc.empty() {
    return NovelDesc(
      title: 'Untitled',
      author: 'Unknown',
      translator: 'Unknown',
      mc: 'Unknown',
      desc: '',
      urls: const [],
      tags: const [],
    );
  }

  NovelDesc copyWith({
    String? title,
    String? author,
    String? translator,
    String? mc,
    String? desc,
    List<String>? urls,
    List<String>? tags,
  }) {
    return NovelDesc(
      title: title ?? this.title,
      author: author ?? this.author,
      translator: translator ?? this.translator,
      mc: mc ?? this.mc,
      desc: desc ?? this.desc,
      urls: urls ?? this.urls,
      tags: tags ?? this.tags,
    );
  }
}
