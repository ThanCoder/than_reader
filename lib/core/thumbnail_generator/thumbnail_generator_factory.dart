import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/thumbnail_generator/app_epub_thumbnail_generator.dart';
import 'package:than_reader/core/thumbnail_generator/i_thumbnail_generator.dart';
import 'package:than_reader/core/thumbnail_generator/app_pdf_thumbnail_generator.dart';

class ThumbnailGeneratorFactory {
  static IThumbnailGenerator create(ReaderFile file) {
    return switch (file.type) {
      .pdf => AppPdfThumbnailGenerator(),
      .epub => AppEpubThumbnailGenerator(),
      _ => throw UnsupportedError('Unsupported Type: ${file.type.name}'),
    };
  }
}
