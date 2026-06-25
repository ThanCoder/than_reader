// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:than_pkg/than_pkg.dart';

class PdfParams {
  final String path;
  final String? password;
  PdfParams({required this.path, this.password});
}

class PdfResult {}

enum PdfThemeMode {
  systemFollow,
  appFollow,
  light,
  dark;

  static PdfThemeMode fromName(String name) {
    if (name == appFollow.name) return .appFollow;
    if (name == light.name) return .light;
    if (name == dark.name) return .dark;
    return .systemFollow;
  }
}

class PdfConfig {
  final int page;
  final double zoom;
  final double offsetX;
  final bool isFullscreen;
  final bool isKeepScreen;
  final PdfThemeMode themeMode;
  final double scrollByMouseWheel;
  final double scrollByArrowKey;
  final ScreenOrientationTypes screenOrientationTypes;
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
  });

  static Future<PdfConfig> fromPath(String path) async {
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
      zoom: 1,
      offsetX: 0,
      isFullscreen: false,
      isKeepScreen: false,
      themeMode: .systemFollow,
      scrollByMouseWheel: 2,
      scrollByArrowKey: 40,
      screenOrientationTypes: .portrait,
    );
  }

  PdfConfig copyWith({
    int? page,
    double? zoom,
    double? offsetX,
    bool? isFullscreen,
    bool? isKeepScreen,
    PdfThemeMode? themeMode,
    double? scrollByMouseWheel,
    double? scrollByArrowKey,
    ScreenOrientationTypes? screenOrientationTypes,
  }) {
    return PdfConfig(
      page: page ?? this.page,
      zoom: zoom ?? this.zoom,
      offsetX: offsetX ?? this.offsetX,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isKeepScreen: isKeepScreen ?? this.isKeepScreen,
      themeMode: themeMode ?? this.themeMode,
      scrollByMouseWheel: scrollByMouseWheel ?? this.scrollByMouseWheel,
      scrollByArrowKey: scrollByArrowKey ?? this.scrollByArrowKey,
      screenOrientationTypes:
          screenOrientationTypes ?? this.screenOrientationTypes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'zoom': zoom,
      'offsetX': offsetX,
      'isFullscreen': isFullscreen,
      'isKeepScreen': isKeepScreen,
      'themeMode': themeMode.name,
      'scrollByMouseWheel': scrollByMouseWheel,
      'scrollByArrowKey': scrollByArrowKey,
      'screenOrientationTypes': screenOrientationTypes.name,
    };
  }

  factory PdfConfig.fromMap(Map<String, dynamic> map) {
    return PdfConfig(
      page: map.getInt(['page']),
      zoom: map.getDouble(['zoom']),
      offsetX: map.getDouble(['offsetX']),
      isFullscreen: map['isFullscreen'] as bool,
      isKeepScreen: map['isKeepScreen'] as bool,
      themeMode: PdfThemeMode.fromName(map.getString(['themeMode'])),
      scrollByMouseWheel: map['scrollByMouseWheel'] as double,
      scrollByArrowKey: map['scrollByArrowKey'] as double,
      screenOrientationTypes: ScreenOrientationTypes.getType(
        map.getString(['screenOrientationTypes']),
      ),
    );
  }
}
