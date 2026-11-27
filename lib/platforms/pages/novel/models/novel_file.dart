class NovelFile {
  final String name;
  final String path;
  final String ext;
  final int size;
  final DateTime date;

  const NovelFile({
    required this.name,
    required this.path,
    required this.ext,
    required this.size,
    required this.date,
  });

  NovelFile copyWith({
    String? name,
    String? path,
    String? ext,
    int? size,
    DateTime? date,
  }) {
    return NovelFile(
      name: name ?? this.name,
      path: path ?? this.path,
      ext: ext ?? this.ext,
      size: size ?? this.size,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'ext': ext,
      'size': size,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory NovelFile.fromJson(Map<String, dynamic> json) {
    return NovelFile(
      name: json['name'],
      path: json['path'],
      ext: json['ext'],
      size: json['size'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
    );
  }
}
