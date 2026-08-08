import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_reader/apps/server/client/downloader/book_downloader_dialog.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookItemMenu extends StatefulWidget {
  final ReaderFile book;
  final String hostUrl;
  final Directory outDir;
  const BookItemMenu({
    super.key,
    required this.book,
    required this.hostUrl,
    required this.outDir,
  });

  @override
  State<BookItemMenu> createState() => _BookItemMenuState();
}

class _BookItemMenuState extends State<BookItemMenu> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 140),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('Download Book'),
              onTap: () {
                context.pop();
                showDownloadDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showDownloadDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookDownloaderDialog(
        book: widget.book,
        hostUrl: widget.hostUrl,
        outDir: widget.outDir,
      ),
    );
  }
}
