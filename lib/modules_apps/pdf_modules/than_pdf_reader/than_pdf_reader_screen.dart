import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/utils/app_theme.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_bookmark_menu.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config_menu.dart';

class ThanPdfReaderScreen extends StatefulWidget {
  final String path;
  final String? password;
  final PdfConfig config;
  const ThanPdfReaderScreen({
    super.key,
    required this.path,
    required this.password,
    required this.config,
  });

  @override
  State<ThanPdfReaderScreen> createState() => _ThanPdfReaderScreenState();
}

class _ThanPdfReaderScreenState extends State<ThanPdfReaderScreen> {
  final controller = TPdfController();
  late PdfConfig config;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    config = widget.config;
    super.initState();
    init();
    initConfig();
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    ThanPkg.platform.toggleKeepScreen(isKeep: false);
    if (Platform.isAndroid) {
      ThanPkg.android.app.requestOrientation(type: .portrait);
    }
    super.dispose();
  }

  void init() {
    controller.onPdfLoaded.listen((event) {
      isLoading = false;
      if (!mounted) return;
      showTSnackBar(
        context,
        'Loaded: ${event.elapsed.autoTimeLabel()}',
        showCloseIcon: true,
      );
      // recent
      controller.jumpToPage(
        config.page,
        offsetX: config.offsetX,
        zoom: config.zoom,
      );
    });
  }

  void initConfig() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: config.isFullscreen);
    ThanPkg.platform.toggleKeepScreen(isKeep: config.isKeepScreen);
    if (Platform.isAndroid) {
      ThanPkg.android.app.requestOrientation(
        type: config.screenOrientationTypes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isLoading) {
          context.pop();
          return;
        }
        context.pop<PdfConfig>(
          config.copyWith(
            page: controller.currentPage,
            pageCount: controller.totalPage,
            zoom: controller.currentZoom,
            offsetX: controller.currentOffsetX,
            isFullscreen: config.isFullscreen,
            isKeepScreen: config.isKeepScreen,
            themeMode: config.themeMode,
            screenOrientationTypes: config.screenOrientationTypes,
            scrollByArrowKey: config.scrollByArrowKey,
            scrollByMouseWheel: config.scrollByMouseWheel,
          ),
        );
      },
      child: Theme(
        data: currentThemeData,
        child: Scaffold(
          appBar: config.isFullscreen
              ? null
              : AppBar(
                  title: Text(
                    widget.path.getName(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
          endDrawer: StreamBuilder(
            stream: controller.onPageChanged,
            builder: (context, asyncSnapshot) {
              return PdfBookmarkMenu(
                config: config,
                currentPage: controller.currentPage,
                onChanged: (config) {
                  this.config = config;
                  setState(() {});
                },
                onNavigate: (navigatePage) {
                  controller.jumpToPage(navigatePage);
                },
              );
            },
          ),
          body: mainWidget,
        ),
      ),
    );
  }

  Widget get mainWidget {
    return Stack(
      children: [
        // pdf
        Positioned.fill(
          left: 0,
          right: 0,
          bottom: 0,
          top: config.isFullscreen ? 0 : 50,
          child: ClipRRect(child: pdfReaderWidget),
        ),

        // header
        if (!config.isFullscreen)
          Positioned(top: 0, left: 0, right: 0, child: headerWidget),
      ],
    );
  }

  Widget get pdfReaderWidget {
    return GestureDetector(
      onDoubleTap: exitFullscreen,
      onLongPress: showConfigMenu,
      onSecondaryTap: showConfigMenu,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.white,
          isDarkMode ? BlendMode.difference : BlendMode.darken,
        ),
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: TPdfReader(path: widget.path, controller: controller),
        ),
      ),
    );
  }

  Widget get headerWidget {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 5,
          children: [
            StreamBuilder(
              stream: controller.onPageChanged,
              builder: (context, asyncSnapshot) {
                // book mark အတွက်
                return GestureDetector(
                  onTap: showGoToDialog,
                  child: Text(
                    '${controller.currentPage}/${controller.totalPage}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: controller.zoomOut,
              icon: Icon(Icons.zoom_out),
            ),
            IconButton(onPressed: controller.zoomIn, icon: Icon(Icons.zoom_in)),
            IconButton(
              onPressed: () {
                if (config.themeMode == .appFollow ||
                    config.themeMode == .systemFollow ||
                    config.themeMode == .light) {
                  config = config.copyWith(themeMode: .dark);
                } else if (config.themeMode == .dark) {
                  config = config.copyWith(themeMode: .light);
                }
                setState(() {});
              },
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
            IconButton(
              onPressed: () {
                config = config.copyWith(isFullscreen: !config.isFullscreen);
                ThanPkg.platform.toggleFullScreen(
                  isFullScreen: config.isFullscreen,
                );
                setState(() {});
              },
              icon: Icon(Icons.fullscreen),
            ),
            // scrollbar
            ValueListenableBuilder(
              valueListenable: controller.scrollbarNotifier,
              builder: (context, enable, child) {
                return IconButton(
                  onPressed: () {
                    controller.setScrollbarEnable(!enable);
                  },
                  icon: Icon(
                    enable ? Icons.unfold_less : Icons.unfold_more_rounded,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get isDarkMode {
    if (config.themeMode == .dark) return true;
    if (config.themeMode == .appFollow) {
      return AppThemeType.isDarkMode;
    }
    if (config.themeMode == .systemFollow) {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == .dark;
    }
    return false;
  }

  ThemeData get currentThemeData {
    if (isDarkMode) return ThemeData.dark();
    return ThemeData.light();
  }

  void exitFullscreen() async {
    if (!config.isFullscreen) return;

    config = config.copyWith(isFullscreen: false);
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);

    setState(() {});
  }

  void showConfigMenu() async {
    final updatedConfig = await showModalBottomSheet<PdfConfig>(
      context: context,
      builder: (context) => PdfConfigMenu(config: config),
    );
    if (updatedConfig == null) return;
    config = updatedConfig;
    setState(() {});
    initConfig();
  }

  void showGoToDialog() {
    final pageNumber = controller.currentPage;
    final pageCount = controller.totalPage;
    showTReanmeDialog(
      context,
      text: pageNumber.toString(),
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      submitText: 'Go To',
      onCheckIsError: (text) {
        final num = int.tryParse(text) ?? 0;
        if (num > pageCount) {
          return '$num > $pageCount';
        }
        return null;
      },
      onSubmit: (text) {
        controller.jumpToPage(int.parse(text));
      },
    );
  }
}
