import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_pdf_engine/than_pdf_engine.dart';
import 'package:than_reader/core/utils/app_utils.dart';

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

  File get cacheFile =>
      File(AppUtils.instance.cachePath.join(pdfPath.getName()));

  @override
  Widget build(BuildContext context) {
    if (cacheFile.existsSync()) {
      return Image.file(cacheFile);
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
        if (cacheFile.existsSync()) {
          return Image.file(cacheFile);
        }
        return Image.asset('assets/images/pdf-icon.webp');
      },
    );
  }
}
