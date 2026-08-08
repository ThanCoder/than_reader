import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:than_reader/apps/server/client/book_thumbnail.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookGridItem extends StatelessWidget {
  final ReaderFile book;
  final String hostUrl;
  final void Function(ReaderFile book)? onClicked;
  final void Function(ReaderFile book)? onMenuClicked;
  const BookGridItem({
    super.key,
    required this.book,
    required this.hostUrl,
    this.onClicked,
    this.onMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => onClicked?.call(book),
      onLongPress: () => onMenuClicked?.call(book),
      onSecondaryTap: () => onMenuClicked?.call(book),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: thumbnail,
                ),
                // Container(color: Colors.black.withValues(alpha: .4)),
                Positioned(top: 0, right: 0, child: bookTypeIconWidget),
              ],
            ),
          ),
          Text(
            book.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget get bookTypeIconWidget {
    if (book.type == .epub) {
      return SvgPicture.asset(
        'assets/svg/epub-svgrepo-com.svg',
        width: 30,
        height: 30,
      );
    }
    if (book.type == .pdf) {
      return SvgPicture.asset(
        'assets/svg/pdf-file-svgrepo-com.svg',
        width: 30,
        height: 30,
      );
    }
    return SvgPicture.asset(
      'assets/svg/file-unknown-svgrepo-com.svg',
      width: 30,
      height: 30,
    );
  }

  Widget get thumbnail {
    return BookThumbnail(book: book,hostUrl: hostUrl,);
  }
}
