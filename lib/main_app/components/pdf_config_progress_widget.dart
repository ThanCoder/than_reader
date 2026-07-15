import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/modules_apps/pdf_modules/config_storage_factory.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';

class PdfConfigProgressWidget extends StatelessWidget {
  final PdfFile pdf;
  const PdfConfigProgressWidget({super.key, required this.pdf});

  @override
  Widget build(BuildContext context) {
    // final config = PdfConfig.fromPathSync(JsonConfigStorage(pdf.configPath));
    // if (config.pageCount == -1 || config.pageCount == 0) {
    //   return SizedBox.shrink();
    // }
    return FutureBuilder(
      future: PdfConfig.fromPath(ConfigStorageFactory.create(pdf.configPath)),
      initialData: PdfConfig.empty(),
      builder: (context, snapshot) {
        final config = snapshot.data!;
        if (config.pageCount == -1 || config.pageCount == 0) {
          return SizedBox.shrink();
        }
        return Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${((config.page / config.pageCount) * 100).toStringAsFixed(2)}% - ${config.page}/${config.pageCount}',
              style: TextStyle(fontSize: 13, color: Colors.amber[700]),
            ),
            LinearProgressIndicator(value: config.page / config.pageCount),
          ],
        );
      },
    );
  }
}
