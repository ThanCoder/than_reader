// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_pkg/than_pkg.dart';

import 'package:than_reader/modules_apps/pdf_modules/interfaces/i_config_storage.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';

class PdfConfig {
  final int page;
  final int pageCount;
  final double zoom;
  final double offsetX;
  final bool isFullscreen;
  final bool isKeepScreen;
  final PdfThemeMode themeMode;
  final double scrollByMouseWheel;
  final double scrollByArrowKey;
  final ScreenOrientationTypes screenOrientationTypes;
  final PdfReaderType readerType;
  final List<PdfBookmark> bookmarkList;
  final List<String> tags;
  final bool showScrollbar;
  const PdfConfig({
    required this.page,
    required this.zoom,
    required this.offsetX,
    required this.isFullscreen,
    required this.isKeepScreen,
    required this.themeMode,
    required this.scrollByMouseWheel,
    required this.scrollByArrowKey,
    required this.screenOrientationTypes,
    required this.pageCount,
    required this.readerType,
    required this.bookmarkList,
    required this.tags,
    required this.showScrollbar,
  });

  static PdfConfig fromPathSync(IConfigStorage storage) {
    return PdfConfig.fromMap(storage.loadSync());
  }

  void savePathSync(IConfigStorage storage) {
    storage.saveSync(toMap());
  }

  static Future<PdfConfig> fromPath(IConfigStorage storage) async {
    return PdfConfig.fromMap(await storage.load());
  }

  Future<void> savePath(IConfigStorage storage) async {
    await storage.save(toMap());
  }

  factory PdfConfig.empty() {
    return PdfConfig(
      page: 1,
      pageCount: -1,
      zoom: 1,
      offsetX: 0,
      isFullscreen: false,
      isKeepScreen: false,
      themeMode: .systemFollow,
      scrollByMouseWheel: 2,
      scrollByArrowKey: 40,
      screenOrientationTypes: .portrait,
      readerType: .autoReader,
      bookmarkList: [],
      tags: [],
      showScrollbar: true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'pageCount': pageCount,
      'zoom': zoom,
      'offsetX': offsetX,
      'isFullscreen': isFullscreen,
      'isKeepScreen': isKeepScreen,
      'themeMode': themeMode.name,
      'scrollByMouseWheel': scrollByMouseWheel,
      'scrollByArrowKey': scrollByArrowKey,
      'screenOrientationTypes': screenOrientationTypes.name,
      'readerType': readerType.name,
      'bookmarkList': bookmarkList.map((e) => e.toMap()).toList(),
      'tags': tags,
      'showScrollbar': showScrollbar,
    };
  }

  factory PdfConfig.fromMap(Map<String, dynamic> map) {
    return PdfConfig(
      page: map.getInt(['page'], def: 0),
      pageCount: map.getInt(['pageCount'], def: 0),
      zoom: map.getDouble(['zoom'], def: 1.0),
      offsetX: map.getDouble(['offsetX']),
      isFullscreen: map.getBool(['isFullscreen']),
      isKeepScreen: map.getBool(['isKeepScreen']),
      themeMode: PdfThemeMode.fromName(map.getString(['themeMode'])),
      scrollByMouseWheel: map.getDouble(['scrollByMouseWheel'], def: 0.2),
      scrollByArrowKey: map.getDouble(['scrollByArrowKey'], def: 25),
      screenOrientationTypes: ScreenOrientationTypes.getType(
        map.getString(['screenOrientationTypes']),
      ),
      readerType: PdfReaderType.fromName(map.getString(['readerType'])),
      bookmarkList: map
          .getList(['bookmarkList'], def: [])
          .map((e) => PdfBookmark.fromMap(e))
          .toList(),
      tags: map.getStringList(['tags'], def: []),
      showScrollbar: map.getBool(['showScrollbar'], def: true),
    );
  }

  PdfConfig copyWith({
    int? page,
    int? pageCount,
    double? zoom,
    double? offsetX,
    bool? isFullscreen,
    bool? isKeepScreen,
    PdfThemeMode? themeMode,
    double? scrollByMouseWheel,
    double? scrollByArrowKey,
    ScreenOrientationTypes? screenOrientationTypes,
    PdfReaderType? readerType,
    List<PdfBookmark>? bookmarkList,
    List<String>? tags,
    bool? showScrollbar,
  }) {
    return PdfConfig(
      page: page ?? this.page,
      pageCount: pageCount ?? this.pageCount,
      zoom: zoom ?? this.zoom,
      offsetX: offsetX ?? this.offsetX,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isKeepScreen: isKeepScreen ?? this.isKeepScreen,
      themeMode: themeMode ?? this.themeMode,
      scrollByMouseWheel: scrollByMouseWheel ?? this.scrollByMouseWheel,
      scrollByArrowKey: scrollByArrowKey ?? this.scrollByArrowKey,
      screenOrientationTypes:
          screenOrientationTypes ?? this.screenOrientationTypes,
      readerType: readerType ?? this.readerType,
      bookmarkList: bookmarkList ?? this.bookmarkList,
      tags: tags ?? this.tags,
      showScrollbar: showScrollbar ?? this.showScrollbar,
    );
  }
}
