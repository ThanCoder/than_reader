// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pdf_engine/than_pdf_engine.dart';
import 'package:than_reader/core/utils/utils.dart';

class PdfThumbnail extends StatelessWidget {
  final String pdfPath;
  final int width;
  final int height;
  const PdfThumbnail({
    super.key,
    required this.pdfPath,
    required this.width,
    required this.height,
  });

  File get cacheFile => File(
    Utils.instance.cachePath.join(
      '${pdfPath.getName(withExt: false)}-w-$width-h-$height-.jpg',
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (cacheFile.existsSync()) {
      return TImageFile(
        path: cacheFile.path,
        defaultAssetsPath: 'assets/images/pdf-icon.webp',
      );
    }
    return FutureBuilder(
      future: PdfCore.genThumbnailJpg(
        pdfPath,
        cacheFile.path,
        width: width,
        height: height,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TImageFile(
          path: cacheFile.path,
          defaultAssetsPath: 'assets/images/pdf-icon.webp',
        );
      },
    );
  }
}
