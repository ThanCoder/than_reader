import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_pdf_reader/t_pdf_reader.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/managers/cache_manager.dart';
import 'package:than_reader/core/models/reader_file.dart';

class ReaderCoverFile extends StatelessWidget {
  final ReaderFile file;
  const ReaderCoverFile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final cacheFile = File(CacheManager.getReaderFileCachePath(file));
    if (cacheFile.existsSync()) {
      return image(cacheFile);
    }
    if (file.type == .pdf) {
      return FutureBuilder(
        future: PdfImageGenerator.instance.generate(
          file.path,
          outPath: cacheFile.path,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return Center(child: TLoader());
          }
          return image(cacheFile);
        },
      );
    }
    return errorImage();
  }

  Widget image(File file) {
    return Image.file(
      file,
      fit: .cover,
      errorBuilder: (context, error, stackTrace) {
        return errorImage();
      },
    );
  }

  Widget errorImage() {
    return Icon(Icons.image_not_supported, size: 100);
  }
}
