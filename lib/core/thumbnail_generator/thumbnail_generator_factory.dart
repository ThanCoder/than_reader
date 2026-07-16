import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';
import 'package:than_reader/core/thumbnail_generator/app_pdf_thumbnail_generator.dart';

class ThumbnailGeneratorFactory {
  static IThumbnailGenerator create(AppFile file) {
    return switch (file.type) {
      .pdf => AppPdfThumbnailGenerator(),
      _ => throw UnsupportedError('Unsupported Type: ${file.type.name}'),
    };
  }
}
