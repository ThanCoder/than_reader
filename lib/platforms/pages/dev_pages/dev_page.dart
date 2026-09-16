class DevPage {
  final String title;
  final String url;
  final String desc;
  final String? iconUrl;

  const DevPage({
    required this.title,
    required this.url,
    required this.desc,
    this.iconUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'desc': desc,
      'iconUrl': iconUrl,
    };
  }

  factory DevPage.fromMap(Map<String, dynamic> map) {
    return DevPage(
      title: map['title'] as String,
      url: map['url'] as String,
      desc: map['desc'] as String,
      iconUrl: map['iconUrl'] != null ? map['iconUrl'] as String : null,
    );
  }
}
