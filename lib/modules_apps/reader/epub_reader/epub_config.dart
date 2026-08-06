// ignore_for_file: public_member_api_docs, sort_constructors_first
class EpubConfig {
  final int currentIndex;
  const EpubConfig({required this.currentIndex});

  factory EpubConfig.empty() {
    return EpubConfig(currentIndex: 0);
  }

  EpubConfig copyWith({int? currentIndex}) {
    return EpubConfig(currentIndex: currentIndex ?? this.currentIndex);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'currentIndex': currentIndex};
  }

  factory EpubConfig.fromMap(Map<String, dynamic> map) {
    return EpubConfig(currentIndex: map['currentIndex'] as int);
  }
}
