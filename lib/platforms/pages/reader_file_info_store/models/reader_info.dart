// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';

class ReaderInfoAdapter extends IDuJsonMetaAdapter<ReaderInfo> {
  @override
  int get adapterId => 1;

  @override
  ReaderInfo fromMap(Map<String, dynamic> map) {
    return .fromMap(map);
  }

  @override
  Map<String, dynamic> toMap(ReaderInfo value) {
    return value.toMap();
  }
}

class ReaderInfo extends IDuModel {
  final String title;
  final String author;
  final String mc;
  final String translator;
  final String coverUrl;
  final List<String> configIds;
  final List<String> urls;
  final List<String> genres;
  final List<String> tags;
  final DateTime date;
  ReaderInfo({
    required this.title,
    required this.author,
    required this.translator,
    required this.configIds,
    required this.urls,
    required this.genres,
    required this.tags,
    required this.coverUrl,
    required this.date,
    required this.mc,
  });
  factory ReaderInfo.empty({
    String? title,
    String? author,
    String? translator,
    String? mc,
    List<String>? configIds,
  }) {
    return .new(
      title: title ?? 'Untitled',
      author: author ?? 'Unknown',
      translator: translator ?? 'Unknown',
      mc: mc ?? 'Unknown',
      configIds: configIds ?? [],
      urls: [],
      genres: [],
      tags: [],
      coverUrl: '',
      date: .now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'translator': translator,
      'configIds': configIds,
      'urls': urls,
      'genres': genres,
      'tags': tags,
      'coverUrl': coverUrl,

      'date': date.millisecondsSinceEpoch,
      'mc': mc,
    };
  }

  factory ReaderInfo.fromMap(Map<String, dynamic> map) {
    return ReaderInfo(
      title: map.getString(['title']),
      author: map.getString(['author']),
      translator: map.getString(['translator']),
      configIds: map.getStringList(['configIds']),
      urls: map.getStringList(['urls']),
      genres: map.getStringList(['genres']),
      tags: map.getStringList(['tags']),
      coverUrl: map.getString(['coverUrl']),

      date: .fromMillisecondsSinceEpoch(map.getInt(['date'])),
      mc: map.getString(['mc']),
    );
  }

  ReaderInfo copyWith({
    String? title,
    String? author,
    String? mc,
    String? translator,
    String? coverUrl,
    List<String>? configIds,
    List<String>? urls,
    List<String>? genres,
    List<String>? tags,
    DateTime? date,
  }) {
    return ReaderInfo(
      title: title ?? this.title,
      author: author ?? this.author,
      mc: mc ?? this.mc,
      translator: translator ?? this.translator,
      coverUrl: coverUrl ?? this.coverUrl,
      configIds: configIds ?? this.configIds,
      urls: urls ?? this.urls,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'mc': mc,
      'translator': translator,
      'coverUrl': coverUrl,
      'configIds': configIds,
      'urls': urls,
      'genres': genres,
      'tags': tags,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ReaderInfo.fromJson(Map<String, dynamic> json) {
    return ReaderInfo(
      title: json['title'],
      author: json['author'],
      mc: json['mc'],
      translator: json['translator'],
      coverUrl: json['coverUrl'],
      configIds: List<String>.from(json['configIds']),
      urls: List<String>.from(json['urls']),
      genres: List<String>.from(json['genres']),
      tags: List<String>.from(json['tags']),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
}
