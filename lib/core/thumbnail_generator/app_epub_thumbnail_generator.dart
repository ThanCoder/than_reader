import 'dart:async';

import 'package:epub_engine/epub_engine.dart';
import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';

class AppEpubThumbnailGenerator implements IThumbnailGenerator {
  @override
  Future<bool> generate(
    String inputPath,
    String outPath, {
    int pageIndex = 0,
    int width = 200,
    int height = 200,
    int quality = 70,
    String? password,
  }) async {
    return await EpubCoverWorker.getInstance.generate(inputPath, outPath);
  }
}
