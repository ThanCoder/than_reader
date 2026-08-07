// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'package:than_reader/modules_apps/reader/pdf_readers/interfaces/i_config_storage.dart';

class EpubConfig {
  final int currentIndex;
  final double maxScroll;
  final double currentScroll;
  final double lastDrawerListOffset;
  final Map<String, bool> expansionTileState;
  const EpubConfig({
    required this.currentIndex,
    required this.currentScroll,
    required this.maxScroll,
    required this.lastDrawerListOffset,
    required this.expansionTileState,
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
    );
  }



  EpubConfig copyWith({
    int? currentIndex,
    double? maxScroll,
    double? currentScroll,
    double? lastDrawerListOffset,
    Map<String, bool>? expansionTileState,
  }) {
    return EpubConfig(
      currentIndex: currentIndex ?? this.currentIndex,
      maxScroll: maxScroll ?? this.maxScroll,
      currentScroll: currentScroll ?? this.currentScroll,
      lastDrawerListOffset: lastDrawerListOffset ?? this.lastDrawerListOffset,
      expansionTileState: expansionTileState ?? this.expansionTileState,
    );
  }

  @override
  String toString() {
    return 'EpubConfig(currentIndex: $currentIndex, maxScroll: $maxScroll, currentScroll: $currentScroll, lastDrawerListOffset: $lastDrawerListOffset, expansionTileState: $expansionTileState)';
  }
}
