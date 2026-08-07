// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'package:than_reader/modules_apps/reader/pdf_readers/interfaces/i_config_storage.dart';

class EpubConfig {
  final int currentIndex;
  final double maxScroll;
  final double currentScroll;
  final double lastDrawerListOffset;
  final Map<String, bool> expansionTileState;
  final String fontFamily;
  final double fontSize;
  const EpubConfig({
    required this.currentIndex,
    required this.currentScroll,
    required this.maxScroll,
    required this.lastDrawerListOffset,
    required this.expansionTileState,
    this.fontFamily = '',
    this.fontSize = -1,
  });

  static EpubConfig fromPathSync(IConfigStorage storage) {
    return EpubConfig.fromMap(storage.loadSync());
  }

  void savePathSync(IConfigStorage storage) {
    storage.saveSync(toMap());
  }

  static Future<EpubConfig> fromPath(IConfigStorage storage) async {
    return EpubConfig.fromMap(await storage.load());
  }

  Future<void> savePath(IConfigStorage storage) async {
    await storage.save(toMap());
  }

  factory EpubConfig.empty() {
    return EpubConfig(
      currentIndex: 0,
      currentScroll: 0,
      maxScroll: 0,
      lastDrawerListOffset: 0,
      expansionTileState: {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentIndex': currentIndex,
      'currentScroll': currentScroll,
      'maxScroll': maxScroll,
      'lastDrawerListOffset': lastDrawerListOffset,
      'expansionTileState': expansionTileState,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
    };
  }

  factory EpubConfig.fromMap(Map<String, dynamic> map) {
    var expansionTileState = <String, bool>{};
    if (map['expansionTileState'] != null) {
      expansionTileState = Map<String, bool>.from(map['expansionTileState']);
    }
    return EpubConfig(
      currentIndex: map.getInt(['currentIndex']),
      currentScroll: map.getDouble(['currentScroll']),
      maxScroll: map.getDouble(['maxScroll']),
      lastDrawerListOffset: map.getDouble(['lastDrawerListOffset']),
      expansionTileState: expansionTileState,
      fontFamily: map.getString(['fontFamily'], def: '-1'),
      fontSize: map.getDouble(['fontSize'], def: -1),
    );
  }

  EpubConfig copyWith({
    int? currentIndex,
    double? maxScroll,
    double? currentScroll,
    double? lastDrawerListOffset,
    Map<String, bool>? expansionTileState,
    String? fontFamily,
    double? fontSize,
  }) {
    return EpubConfig(
      currentIndex: currentIndex ?? this.currentIndex,
      maxScroll: maxScroll ?? this.maxScroll,
      currentScroll: currentScroll ?? this.currentScroll,
      lastDrawerListOffset: lastDrawerListOffset ?? this.lastDrawerListOffset,
      expansionTileState: expansionTileState ?? this.expansionTileState,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  @override
  String toString() {
    return 'EpubConfig(currentIndex: $currentIndex, maxScroll: $maxScroll, currentScroll: $currentScroll, lastDrawerListOffset: $lastDrawerListOffset, expansionTileState: $expansionTileState, fontFamily: $fontFamily, fontSize: $fontSize)';
  }
}
