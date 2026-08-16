import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';
import 'package:than_reader/apps/pdf/pdf_jump_page_dialog.dart';
import 'package:than_reader/core/models/reader_file.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({super.key, required this.file});

  final ReaderFile file;

  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  late final TPdfController controller;

  @override
  void initState() {
    controller = TPdfController(
      onKeyEvent: (node, event) {
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
            controller.zoomOut();
            return .handled;
          }
          if (event.physicalKey == .equal) {
            controller.zoomIn();
            return .handled;
          }
        }
        return .ignored;
      },
      scrollbarWidget: (thumbWidth, thumbHeight) => defaultScrollbarNeon(
        thumbWidth: thumbWidth,
        thumbHeight: thumbHeight,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDarkMode = false;
  bool isFullscreen = false;

  void init() {}

  void existsFullscreen() {
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(false);
    }
    setState(() {
      isFullscreen = false;
    });
  }

  void toggleFullscreen() {
    isFullscreen = !isFullscreen;
    if (Platform.isLinux) {
      ThanPkgLinux.getInstance.window.setFullscreen(isFullscreen);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return Scaffold(
      backgroundColor: col.surface,
      appBar: isFullscreen ? null : AppBar(title: Text('PDF Reader')),
      body: Stack(
        children: [
          Positioned.fill(
            top: isFullscreen ? 0 : 60,
            left: 0,
            right: 0,
            child: _pdfReader(),
          ),
          if (!isFullscreen)
            Positioned(top: 0, left: 0, right: 0, child: _header()),
        ],
      ),
    );
  }

  ClipRRect _pdfReader() {
    return ClipRRect(
      child: ColorFiltered(
        colorFilter: .mode(Colors.white, isDarkMode ? .difference : .dstIn),
        child: TPdfReader(path: widget.file.path, controller: controller),
      ),
    );
  }

  Widget _header() {
    final col = context.colorScheme;
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Padding(
        padding: .all(8),
        child: Row(
          spacing: 8,
          children: [
            SizedBox(width: 40),
            InkWell(
              borderRadius: .circular(30),
              onTap: showGoToDialog,
              child: Container(
                padding: .all(8),
                decoration: BoxDecoration(
                  color: col.primary.withValues(alpha: .45),
                  borderRadius: .circular(15),
                  boxShadow: [
                    .new(
                      color: col.primary.withValues(alpha: .60),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: StreamBuilder(
                  stream: controller.onPageChanged,
                  builder: (context, asyncSnapshot) {
                    return Text(
                      '${controller.currentPage}/${controller.totalPage}',
                      style: TextStyle(color: col.onPrimary),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 20),
            // dark mode
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainer,
                foregroundColor: col.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(30),
                  boxShadow: [
                    .new(
                      color: col.primary.withValues(alpha: .45),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(Icons.dark_mode),
              ),
            ),
            // zoom out
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainer,
                foregroundColor: col.onSurfaceVariant,
              ),
              onPressed: () {
                controller.zoomOut();
              },
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(30),
                  boxShadow: [
                    .new(
                      color: col.primary.withValues(alpha: .45),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(Icons.zoom_out),
              ),
            ),
            // zoom int
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainer,
                foregroundColor: col.onSurfaceVariant,
              ),
              onPressed: () {
                controller.zoomIn();
              },
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: .circular(30),
                  boxShadow: [
                    .new(
                      color: col.primary.withValues(alpha: .45),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(Icons.zoom_in),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showGoToDialog() async {
    final jump = await showDialog<int>(
      context: context,
      builder: (context) => PdfJumpPageDialog(
        current: controller.currentPage,
        maxPage: controller.totalPage,
      ),
    );
    if (jump == null) return;
    controller.jumpToPage(jump);
  }
}
