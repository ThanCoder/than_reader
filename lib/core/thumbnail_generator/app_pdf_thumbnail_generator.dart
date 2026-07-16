import 'package:than_pdf_engine/than_pdf_engine.dart';
import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';

class AppPdfThumbnailGenerator implements IThumbnailGenerator {
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
    return await PdfThumbnailGenerator.instance.generate(
      inputPath,
      outPath,
      width: width,
      height: height,
      quality: 90,
    );
  }
}
