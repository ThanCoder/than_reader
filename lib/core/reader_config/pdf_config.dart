// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';

import 'package:than_reader/apps/pdf/config_widget/pdf_reader_prefer_theme_mode_chooser.dart';
import 'package:than_reader/apps/pdf/pdf_config_bookmark.dart';
import 'package:than_reader/apps/pdf/reader_theme_mode.dart';
import 'package:than_reader/apps/pdf/screen_orientation.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class PdfConfig {
  const PdfConfig({
    required this.page,
    required this.totalPage,
    required this.zoom,
    required this.offsetX,
    required this.isFullscreen,
    required this.isKeepScreen,
    required this.scrollbarEnable,
    required this.orientation,
    required this.readerThemeMode,
    required this.bookmark,
    required this.preloadPageCount,
    required this.renderImageType,
    required this.isAdult,
    required this.isCompleted,
  });

  final int page;
  final int totalPage;
  final double zoom;
  final double offsetX;
  final bool isFullscreen;
  final bool isKeepScreen;
  final bool scrollbarEnable;
  final ScreenOrientation orientation;
  final ReaderThemeMode readerThemeMode;
  final List<PdfConfigBookmark> bookmark;
  final int preloadPageCount;
  final PageRenderImageType renderImageType;
  final bool isAdult;
  final bool isCompleted;

  factory PdfConfig.empty() {
    return .new(
      page: 1,
      totalPage: 0,
      zoom: 1,
      offsetX: 0,
      isFullscreen: false,
      isKeepScreen: false,
      scrollbarEnable: AppUtil.instance.config.getBool(
        pdfReaderPreferScrollbarEnableKey,
        true,
      ),
      readerThemeMode: PdfReaderPreferThemeModeChooser.currentNotifier.value,
      orientation: .portrait,
      bookmark: [],
      preloadPageCount: 2,
      renderImageType: .jpg,
      isAdult: false,
      isCompleted: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'totalPage': totalPage,
      'zoom': zoom,
      'offsetX': offsetX,
      'isFullscreen': isFullscreen,
      'isKeepScreen': isKeepScreen,
      'scrollbarEnable': scrollbarEnable,
      'orientation': orientation.name,
      'readerThemeMode': readerThemeMode.name,
      'bookmark': bookmark.map((e) => e.toMap()).toList(),
      'preloadPageCount': preloadPageCount,
      'renderImageType': renderImageType.name,
      'isAdult': isAdult,
      'isCompleted': isCompleted,
    };
  }

  factory PdfConfig.fromMap(Map<String, dynamic> map) {
    return PdfConfig(
      isAdult: map.getBool(['isAdult']),
      isCompleted: map.getBool(['isCompleted']),
      page: map['page'] as int,
      totalPage: map['totalPage'] as int,
      zoom: map['zoom'] as double,
      offsetX: map['offsetX'] as double,
      isFullscreen: map['isFullscreen'] as bool,
      isKeepScreen: map.getBool(['isKeepScreen']),
      scrollbarEnable: map.getBool(
        ['scrollbarEnable'],
        def: AppUtil.instance.config.getBool(
          pdfReaderPreferScrollbarEnableKey,
          true,
        ),
      ),
      orientation: ScreenOrientation.fromValue(map.getString(['orientation'])),
      readerThemeMode: ReaderThemeMode.fromValue(
        map.getString(['readerThemeMode']),
      ),
      bookmark: map
          .getMapList(['bookmark'])
          .map((e) => PdfConfigBookmark.fromMap(e))
          .toList(),
      preloadPageCount: map.getInt([
        'preloadPageCount',
      ], def: pdfReaderPreloadPageCount),
      renderImageType: .fromValue(map.getString(['renderImageType'])),
    );
  }

  PdfConfig copyWith({
    int? page,
    int? totalPage,
    double? zoom,
    double? offsetX,
    bool? isFullscreen,
    bool? isKeepScreen,
    bool? scrollbarEnable,
    ScreenOrientation? orientation,
    ReaderThemeMode? readerThemeMode,
    List<PdfConfigBookmark>? bookmark,
    int? preloadPageCount,
    PageRenderImageType? renderImageType,
    bool? isAdult,
    bool? isCompleted,
  }) {
    return PdfConfig(
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      zoom: zoom ?? this.zoom,
      offsetX: offsetX ?? this.offsetX,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      isKeepScreen: isKeepScreen ?? this.isKeepScreen,
      scrollbarEnable: scrollbarEnable ?? this.scrollbarEnable,
      orientation: orientation ?? this.orientation,
      readerThemeMode: readerThemeMode ?? this.readerThemeMode,
      bookmark: bookmark ?? this.bookmark,
      preloadPageCount: preloadPageCount ?? this.preloadPageCount,
      renderImageType: renderImageType ?? this.renderImageType,
      isAdult: isAdult ?? this.isAdult,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
