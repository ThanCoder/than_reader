import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/config_storage_factory.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdf_config.dart';

class ReaderFileConfigProgressWidget extends StatelessWidget {
  final ReaderFile pdf;
  const ReaderFileConfigProgressWidget({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PdfConfig.fromPath(ConfigStorageFactory.create(pdf.configPath)),
      initialData: PdfConfig.empty(),
      builder: (context, snapshot) {
        final config = snapshot.data!;
        int page = config.page;
        int pageCount = config.pageCount;

        if (page == -1 || pageCount == 0) {
          return SizedBox.shrink();
        }
        return Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${((page / pageCount) * 100).toStringAsFixed(2)}% - $page/$pageCount',
              style: TextStyle(fontSize: 13, color: Colors.amber[700]),
            ),
            LinearProgressIndicator(value: page / config.pageCount),
          ],
        );
      },
    );
  }
}
