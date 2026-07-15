import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';
import 'package:than_reader/core/utils/thumbnail_manager.dart';

class PdfThumbnailGenerator implements IThumbnailGenerator {
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
    return await ThumbnailManager.generate(
      inputPath,
      outPath,
      width: width,
      height: height,
      quality: 90,
    );
  }
}
