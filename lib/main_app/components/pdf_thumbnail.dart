// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/apps/thumbnail_generator/thumbnail_generator_factory.dart';

class PdfThumbnail extends StatelessWidget {
  final ReaderFile file;
  final int width;
  final int height;
  const PdfThumbnail({
    super.key,
    required this.file,
    required this.width,
    required this.height,
  });

  File get cacheFile => File(
    file.cacheCoverPath,
    // PathBuf(
    //   Utils.instance.cachePath,
    // ).join('${file.path.getName(withExt: false)}-w-$width-h-$height.jpg').path,
  );

  @override
  Widget build(BuildContext context) {
    // print(cacheFile.path);

    if (cacheFile.existsSync()) {
      return TImageFile(
        path: cacheFile.path,
        defaultAssetsPath: 'assets/images/pdf-icon.webp',
      );
    }
    return FutureBuilder(
      future: ThumbnailGeneratorFactory.create(file).generate(
        file.path,
        cacheFile.path,
        width: width,
        height: height,
        quality: 90,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return TImageFile(
          path: cacheFile.path,
          defaultAssetsPath: 'assets/images/pdf-icon.webp',
          errorBuilder: (context, error, stackTrace) {
            cacheFile.deleteSync();
            return Text('error');
          },
        );
      },
    );
  }
}
