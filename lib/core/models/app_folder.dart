// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppFolder {
  final String name;
  final String path;
  final int size;
  final DateTime date;
  const AppFolder({
    required this.name,
    required this.path,
    required this.size,
    required this.date,
  });

  AppFolder copyWith({String? name, String? path, int? size, DateTime? date}) {
    return AppFolder(
      name: name ?? this.name,
      path: path ?? this.path,
      size: size ?? this.size,
      date: date ?? this.date,
    );
  }
}
