import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';
import 'package:than_reader/core/thumbnail_generator/pdf_thumbnail_generator.dart';

class ThumbnailGeneratorFactory {
  static IThumbnailGenerator create(AppFile file) {
    return switch (file.type) {
      .pdf => PdfThumbnailGenerator(),
      _ => throw UnsupportedError('Unsupported Type: ${file.type.name}'),
    };
  }
}
