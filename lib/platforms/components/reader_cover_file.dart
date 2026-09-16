import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/managers/cache_manager.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/platform_util.dart';

class ReaderCoverFile extends StatelessWidget {
  const ReaderCoverFile({super.key, required this.file, this.borderRadius});
  final ReaderFile file;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? .circular(15),
      child: bodyWidget,
    );
  }

  Widget get bodyWidget {
    final cacheFile = File(CacheManager.getBookThumbnailCachePath(file));
    if (cacheFile.existsSync()) {
      return image(cacheFile);
    }
    return FutureBuilder(
      future: PlatformUtil.genThumbnail(
        file.path,
        outPath: cacheFile.path,
        type: file.type,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: TLoader());
        }
        return image(cacheFile);
      },
    );
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
