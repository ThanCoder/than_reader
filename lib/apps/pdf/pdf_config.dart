import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/apps/pdf/reader_theme_mode.dart';
import 'package:than_reader/apps/pdf/screen_orientation.dart';

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

  factory PdfConfig.empty() {
    return .new(
      page: 1,
      totalPage: 0,
      zoom: 1,
      offsetX: 0,
      isFullscreen: false,
      isKeepScreen: false,
      scrollbarEnable: true,
      readerThemeMode: .followAppTheme,
      orientation: .portrait,
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
    };
  }

  factory PdfConfig.fromMap(Map<String, dynamic> map) {
    return PdfConfig(
      page: map['page'] as int,
      totalPage: map['totalPage'] as int,
      zoom: map['zoom'] as double,
      offsetX: map['offsetX'] as double,
      isFullscreen: map['isFullscreen'] as bool,
      isKeepScreen: map['isKeepScreen'] as bool,
      scrollbarEnable: map['scrollbarEnable'] as bool,
      orientation: ScreenOrientation.fromValue(map.getString(['orientation'])),
      readerThemeMode: ReaderThemeMode.fromValue(
        map.getString(['readerThemeMode']),
      ),
    );
  }

  @override
  String toString() {
    return 'PdfConfig(page: $page, totalPage: $totalPage, zoom: $zoom, offsetX: $offsetX, isFullscreen: $isFullscreen, isKeepScreen: $isKeepScreen, scrollbarEnable: $scrollbarEnable, orientation: $orientation, readerThemeMode: $readerThemeMode)';
  }
}
