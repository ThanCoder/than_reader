import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';
import 'package:than_reader/apps/pdf/reader_theme_mode.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({super.key, required this.file, required this.config});

  final ReaderFile file;
  final PdfConfig config;

  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  late final TPdfController controller;
  late PdfConfig config;

  @override
  void initState() {
    config = widget.config;
    controller = TPdfController(
      widgetBuilder: TPdfWidgetBuilder(
        footerBuilder: (context, page) =>
            isDarkMode ? SizedBox.shrink() : Text('Page: $page'),
      ),
      eventBuilder: TPdfEventBuilder(
        onKeyEventAfterConfig: (node, event) {
          if (event is KeyDownEvent) {
            if (event.physicalKey == .keyF) {
              toggleFullscreen();
              return .handled;
            }
            if (event.physicalKey == .escape) {
              existsFullscreen();
              return .handled;
            }
            // print(event.physicalKey);
            if (event.physicalKey == .minus) {
              controller.action.zoomOut();
              return .handled;
            }
            if (event.physicalKey == .equal) {
              controller.action.zoomIn();
              return .handled;
            }
          }
          return .ignored;
        },
      ),
    );
    super.initState();
    controller.attached.listen((_) {
      controller.stream.ready.listen((_) {
        init();
      });
    });
    changedConfig();
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.orientationHandler.setOrientation(
        .SCREEN_ORIENTATION_PORTRAIT,
      );
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(false);
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(false);
    }
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(false);
    }
    super.dispose();
  }

  void changedConfig() {
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.orientationHandler.setOrientation(
        config.orientation.toMode,
      );
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(config.isKeepScreen);
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(
        config.isFullscreen,
      );
    }
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(config.isFullscreen);
    }
  }

  bool isReady = false;
  void init() {
    if (config.zoom != 1) {
      controller.action.setZoom(config.zoom);
    } else {
      controller.action.setFitZoom();
    }
    if (config.page != 1) {
      controller.action.jumpPage(config.page);
    }
    setState(() {
      isReady = true;
    });
  }

  void existsFullscreen() {
    if (config.isFullscreen == false) return;
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(false);
    }
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(false);
    }
    config = config.copyWith(isFullscreen: false);
    setState(() {});
  }

  void toggleFullscreen() {
    config = config.copyWith(isFullscreen: !config.isFullscreen);
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(config.isFullscreen);
    }
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(
        config.isFullscreen,
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: existsFullscreen,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          saveConfig();
        },
        child: Theme(
          data: currentTheme,
          child: Builder(
            builder: (context) {
              final col = context.colorScheme;
              return Scaffold(
                backgroundColor: col.surface,
                appBar: config.isFullscreen
                    ? null
                    : AppBar(title: Text('PDF Reader')),
                body: Stack(
                  children: [
                    Positioned.fill(
                      top: config.isFullscreen ? 0 : 60,
                      left: 0,
                      right: 0,
                      child: _pdfReader(),
                    ),
                    if (!config.isFullscreen)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _header(col),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _pdfReader() {
    BlendMode blendMode = .dstIn;
    if (isReady) {
      blendMode = isDarkMode ? .difference : .dstIn;
    }
    return ClipRRect(
      child: ColorFiltered(
        colorFilter: .mode(Colors.white, blendMode),
        child: TPdfReader(path: widget.file.path, controller: controller),
      ),
    );
  }

  Widget _header(ColorScheme col) {
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Padding(
        padding: .all(8),
        child: Row(
          spacing: 8,
          children: [
            SizedBox(width: 2),
            PdfPageListener(
              controller: controller,
              onClicked: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      PdfPageJumpDialog(controller: controller),
                );
              },
            ),
            SizedBox(width: 2),
            // dark mode
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainerHigh,
                foregroundColor: col.onSurface,
              ),
              onPressed: () {
                ReaderThemeMode? newMode;
                if (config.readerThemeMode == .light) {
                  newMode = .dark;
                } else if (config.readerThemeMode == .dark) {
                  newMode = .light;
                } else {
                  newMode = .dark;
                }
                config = config.copyWith(readerThemeMode: newMode);
                setState(() {});
              },
              icon: Icon(
                isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
            // fullscreen
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainerHigh,
                foregroundColor: col.onSurface,
              ),
              onPressed: toggleFullscreen,
              icon: Icon(Icons.fullscreen),
            ),
            // zoom out
            PdfZoomOut(controller: controller),
            // zoom int
            PdfZoomIn(controller: controller),

            PdfZoomListener(controller: controller),
            PdfScrollbarToggler(controller: controller),
            PdfCacheImageListener(controller: controller),
          ],
        ),
      ),
    );
  }

  ThemeData get currentTheme {
    if (config.readerThemeMode == .light) return .light();
    if (config.readerThemeMode == .dark) return .dark();

    return context.isDarkMode ? .dark() : .light();
  }

  bool get isDarkMode {
    return currentTheme == .dark() ? true : false;
  }

  void saveConfig() {
    final state = controller.state;
    final newCof = config.copyWith(
      page: state.page,
      totalPage: state.totalPage,
      offsetX: state.currentOffsetX,
      scrollbarEnable: state.scrollbarEnable,
      zoom: state.zoom,
    );
    Navigator.pop<PdfConfig>(context, newCof);
  }
}
