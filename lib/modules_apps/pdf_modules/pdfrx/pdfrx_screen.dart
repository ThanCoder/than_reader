import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/utils/app_theme.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config_menu.dart';

class PdfrxScreen extends StatefulWidget {
  final String path;
  final String? password;
  final PdfConfig config;
  const PdfrxScreen({
    super.key,
    required this.path,
    required this.password,
    required this.config,
  });

  @override
  State<PdfrxScreen> createState() => _PdfrxScreenState();
}

class _PdfrxScreenState extends State<PdfrxScreen> {
  final controller = PdfViewerController();
  final loadingNotifier = ValueNotifier<bool>(false);
  final pageChangedNotifier = ValueNotifier<(int, int)>((0, 0));
  late PdfConfig config;

  @override
  void initState() {
    config = widget.config;
    loadingNotifier.value = true;
    super.initState();
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

  void initConfig() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: config.isFullscreen);
    ThanPkg.platform.toggleKeepScreen(isKeep: config.isKeepScreen);
    if (Platform.isAndroid) {
      ThanPkg.android.app.requestOrientation(
        type: config.screenOrientationTypes,
      );
    }
  }

  void onDocumentLoadFinished() async {
    loadingNotifier.value = false;
    pageChangedNotifier.value = (controller.pageCount, controller.pageNumber!);

    await controller.goToPage(pageNumber: config.page);
    final centerPos = controller.centerPosition;
    if (config.offsetX != 0) {
      controller.setZoom(Offset(config.offsetX, centerPos.dy), config.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (loadingNotifier.value) {
          context.pop();
          return;
        }
        context.pop<PdfConfig>(
          config.copyWith(
            page: controller.pageNumber,
            pageCount: controller.pageCount,
            zoom: controller.currentZoom,
            offsetX: controller.centerPosition.dx,
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
          body: mainWidget,
        ),
      ),
    );
  }

  PdfViewerParams get params => PdfViewerParams(
    textSelectionParams: PdfTextSelectionParams(enabled: false),
    pageDropShadow: null,
    scrollByMouseWheel: config.scrollByMouseWheel,
    scrollByArrowKey: config.scrollByArrowKey,
    margin: 0,
    scrollPhysicsScale: BouncingScrollPhysics(),
    panAxis: PanAxis.vertical,
    onDocumentLoadFinished: (documentRef, loadSucceeded) =>
        onDocumentLoadFinished(),
    onPageChanged: (pageNumber) {
      if (pageNumber == null) return;
      pageChangedNotifier.value = (controller.pageCount, pageNumber);
    },
    loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
      return Center(child: CircularProgressIndicator.adaptive());
    },
    pageOverlaysBuilder: (context, pageRectInViewer, page) => [
      Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          'Page: ${page.pageNumber}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    ],
    onKey: (params, key, isRealKeyPress) {
      if (key == LogicalKeyboardKey.escape) {
        exitFullscreen();
        return true;
      }
      return false;
    },
    onGeneralTap: (context, controller, details) {
      if (details.type == .doubleTap) {
        exitFullscreen();
        return true;
      }
      if (details.type == .secondaryTap || details.type == .longPress) {
        showConfigMenu();
        return true;
      }
      return false;
    },
  );

  Widget get mainWidget {
    return Stack(
      children: [
        // pdf
        Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              top: config.isFullscreen ? 0 : 50,
              child: ClipRRect(child: pdfReaderWidget),
            ),
          ],
        ),

        // header
        if (!config.isFullscreen)
          Positioned(top: 0, left: 0, right: 0, child: headerWidget),
        Positioned(top: 0, left: 0, right: 0, child: loaderWidget),
      ],
    );
  }

  Widget get pdfReaderWidget {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.white,
        isDarkMode ? BlendMode.difference : BlendMode.darken,
      ),
      child: PdfViewer.file(
        useProgressiveLoading: false,
        passwordProvider: () => widget.password,
        widget.path,
        controller: controller,
        params: params,
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
            ValueListenableBuilder<(int, int)>(
              valueListenable: pageChangedNotifier,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: showGoToDialog,
                  child: Text(
                    '${value.$2}/${value.$1}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                controller.zoomDown();
              },
              icon: Icon(Icons.zoom_out),
            ),
            IconButton(
              onPressed: () {
                controller.zoomUp();
              },
              icon: Icon(Icons.zoom_in),
            ),
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
          ],
        ),
      ),
    );
  }

  Widget get loaderWidget {
    return ValueListenableBuilder(
      valueListenable: loadingNotifier,
      builder: (context, value, child) {
        if (value) {
          return LinearProgressIndicator();
        }
        return SizedBox.shrink();
      },
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
    final centerPosition = controller.centerPosition;
    final zoom = controller.currentZoom;

    config = config.copyWith(isFullscreen: false);
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);

    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    controller.setZoom(centerPosition, zoom);
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
    final pageNumber = controller.pageNumber!;
    final pageCount = controller.pageCount;
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
        controller.goToPage(pageNumber: int.parse(text));
      },
    );
  }
}
