// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';

import 'package:than_reader/core/models/reader_file.dart';

class ReaderInfoAdapter extends IDuBinaryMetaAdapter<ReaderInfo> {
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
  final String translator;
  final String coverUrl;
  final List<String> configIds;
  final List<String> urls;
  final List<String> geners;
  final List<String> tags;
  final FileType type;
  ReaderInfo({
    required this.title,
    required this.author,
    required this.translator,
    required this.configIds,
    required this.urls,
    required this.geners,
    required this.tags,
    required this.coverUrl,
    required this.type,
  });
  factory ReaderInfo.empty() {
    return .new(
      title: 'Untitled',
      author: 'Unknown',
      translator: 'Unknown',
      configIds: [],
      urls: [],
      geners: [],
      tags: [],
      coverUrl: '',
      type: .pdf,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'translator': translator,
      'configIds': configIds,
      'urls': urls,
      'geners': geners,
      'tags': tags,
      'coverUrl': coverUrl,
      'type': type.name,
    };
  }

  factory ReaderInfo.fromMap(Map<String, dynamic> map) {
    return ReaderInfo(
      title: map.getString(['title']),
      author: map.getString(['author']),
      translator: map.getString(['translator']),
      configIds: map.getStringList(['configIds']),
      urls: map.getStringList(['urls']),
      geners: map.getStringList(['geners']),
      tags: map.getStringList(['tags']),
      coverUrl: map.getString(['coverUrl']),
      type: .fromValue(map.getString(['type'])),
    );
  }

  ReaderInfo copyWith({
    String? title,
    String? author,
    String? translator,
    List<String>? configIds,
    List<String>? urls,
    List<String>? geners,
    List<String>? tags,
    String? coverUrl,
    FileType? type,
  }) {
    return ReaderInfo(
      title: title ?? this.title,
      author: author ?? this.author,
      translator: translator ?? this.translator,
      configIds: configIds ?? this.configIds,
      urls: urls ?? this.urls,
      geners: geners ?? this.geners,
      tags: tags ?? this.tags,
      coverUrl: coverUrl ?? this.coverUrl,
      type: type ?? this.type,
    );
  }
}
