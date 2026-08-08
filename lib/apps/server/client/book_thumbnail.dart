import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookThumbnail extends StatelessWidget {
  final ReaderFile book;
  final String hostUrl;
  const BookThumbnail({super.key, required this.book, required this.hostUrl});

  @override
  Widget build(BuildContext context) {
    final url = '$hostUrl/api/book/cover/${book.configId}';
    // print('url: $url');
    return TImage(
      source: url,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.image_not_supported, size: 100),
    );
  }
}
