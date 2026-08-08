import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookDownloaderDialog extends StatefulWidget {
  final ReaderFile book;
  final String hostUrl;
  final Directory outDir;
  const BookDownloaderDialog({
    super.key,
    required this.book,
    required this.hostUrl,
    required this.outDir,
  });

  @override
  State<BookDownloaderDialog> createState() => _BookDownloaderDialogState();
}

class _BookDownloaderDialogState extends State<BookDownloaderDialog> {
  final client = TClient();

  bool isDownloading = false;
  bool isDownload = false;
  String? message;
  final progressNotifier = ValueNotifier<double?>(null);
  Future<void> startDownload() async {
    try {
      if (!widget.outDir.existsSync()) {
        await widget.outDir.create(recursive: true);
      }
      setState(() {
        isDownloading = true;
        message = null;
        isDownload = false;
      });

      await client.download(
        downloadUrl,
        savePath: savePath,
        onError: (message) {
          this.message = message;
          if (!mounted) return;
          setState(() {});
        },
        onReceiveProgress: (received, total) {
          progressNotifier.value = (received / total);
        },
      );
      if (!mounted) return;
      setState(() {
        isDownloading = false;
        isDownload = true;
      });
    } catch (e) {
      message = e.toString();
      if (!mounted) return;
      setState(() {
        isDownloading = false;
      });
    }
  }

  String get downloadUrl =>
      '${widget.hostUrl}/api/book/download/${widget.book.configId}';
  String get savePath => '${widget.outDir.path}/${widget.book.name}';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Downloader', maxLines: 2, overflow: .ellipsis),
      content: Column(
        children: [
          infoWidget,
          if (message != null)
            Text(message!, style: TextStyle(fontSize: 14, color: Colors.red)),
          if (isDownload)
            Text(
              'File Downloaded\nPath: $savePath',
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),

          if (isDownloading) progressWidget,
        ],
      ),
      actions: actionWidget,
    );
  }

  Widget get infoWidget {
    return Column(
      crossAxisAlignment: .start,
      spacing: 2,
      children: [
        Text('T: ${widget.book.name}', style: TextStyle(fontSize: 15)),
        SizedBox(height: 4),
        Text('Size: ${widget.book.size.fileSizeLabel()}'),
        Text('Time Ago: ${widget.book.date.formatTimeAgo()}'),
      ],
    );
  }

  Widget get progressWidget {
    return ValueListenableBuilder(
      valueListenable: progressNotifier,
      builder: (context, value, child) {
        return Column(
          children: [
            if (progressNotifier.value != null)
              Text(
                'Progress: ${(progressNotifier.value! * 100).toStringAsFixed(2)}%',
              ),
            LinearProgressIndicator(value: progressNotifier.value),
          ],
        );
      },
    );
  }

  List<Widget> get actionWidget {
    return [
      if (!isDownloading)
        TextButton(
          onPressed: () {
            startDownload();
          },
          child: Text(isDownload ? 'Redownload' : 'Start Download'),
        ),
      TextButton(
        onPressed: isDownloading
            ? null
            : () {
                context.pop();
              },
        child: Text('Close'),
      ),
    ];
  }
}
