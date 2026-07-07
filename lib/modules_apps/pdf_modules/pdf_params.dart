// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:than_pkg/than_pkg.dart';

class PdfParams {
  final String path;
  final String? password;
  final String configPath;
  PdfParams({required this.path, required this.configPath, this.password});
}

class PdfResult {}

enum PdfThemeMode {
  systemFollow,
  appFollow,
  light,
  dark;

  static PdfThemeMode fromName(String name) {
    if (name == systemFollow.name) return .systemFollow;
    if (name == light.name) return .light;
    if (name == dark.name) return .dark;
    return .appFollow;
  }
}

enum PdfReaderType {
  autoReader,
  thanPdfReader,
  pdfrxReader;

  static PdfReaderType fromName(String name) {
    if (name == thanPdfReader.name) return .thanPdfReader;
    if (name == pdfrxReader.name) return .pdfrxReader;
    return .autoReader;
  }
}

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
  });

  static PdfConfig fromPath(String path) {
    final configFile = File(path);
    if (!configFile.existsSync()) return PdfConfig.empty();
    try {
      final map = jsonDecode(configFile.readAsStringSync());
      return PdfConfig.fromMap(map);
    } catch (e) {
      debugPrint('[PdfConfig:fromPath]: $e');
    }
    return PdfConfig.empty();
  }

  Future<void> savePath(String path) async {
    final configFile = File(path);
    await configFile.writeAsString(jsonEncode(toMap()));
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
    };
  }

  factory PdfConfig.fromMap(Map<String, dynamic> map) {
    return PdfConfig(
      page: map['page'] as int,
      pageCount: map.getInt(['pageCount'], def: -1),
      zoom: map['zoom'] as double,
      offsetX: map['offsetX'] as double,
      isFullscreen: map['isFullscreen'] as bool,
      isKeepScreen: map['isKeepScreen'] as bool,
      themeMode: PdfThemeMode.fromName(map.getString(['themeMode'])),
      scrollByMouseWheel: map['scrollByMouseWheel'] as double,
      scrollByArrowKey: map['scrollByArrowKey'] as double,
      screenOrientationTypes: ScreenOrientationTypes.getType(
        map.getString(['screenOrientationTypes']),
      ),
      readerType: PdfReaderType.fromName(map.getString(['readerType'])),
      bookmarkList: map
          .getList(['bookmarkList'], def: [])
          .map((e) => PdfBookmark.fromMap(e))
          .toList(),
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
    );
  }
}

class PdfBookmark {
  final int page;
  final String title;
  PdfBookmark({required this.page, required this.title});

  PdfBookmark copyWith({int? page, String? title}) {
    return PdfBookmark(page: page ?? this.page, title: title ?? this.title);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'page': page, 'title': title};
  }

  factory PdfBookmark.fromMap(Map<String, dynamic> map) {
    return PdfBookmark(
      page: map.getInt(['page']),
      title: map.getString(['title'], def: 'Untitled'),
    );
  }
}
