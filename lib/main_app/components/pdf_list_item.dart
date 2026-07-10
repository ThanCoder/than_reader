import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/main_app/components/fav_toggle_button.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';
import 'package:than_reader/main_app/components/tag_button.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';

class PdfListItem extends StatelessWidget {
  final PdfFile pdf;
  final void Function(PdfFile pdf)? onClicked;
  final void Function(PdfFile pdf)? onMenuClicked;
  const PdfListItem({
    super.key,
    required this.pdf,
    this.onClicked,
    this.onMenuClicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => onClicked?.call(pdf),
      onLongPress: () => onMenuClicked?.call(pdf),
      onSecondaryTap: () => onMenuClicked?.call(pdf),
      child: Row(
        spacing: 4,
        children: [
          SizedBox(width: 100, height: 130, child: thumbnail),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(
                  pdf.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13),
                ),
                Text('Size: ${pdf.size.toFileSizeLabel()}'),
                Text('Date: ${pdf.date.formatTimeAgo()}'),
                // progress
                progressWidget,
                Wrap(
                  children: [
                    FavToggleButton(file: pdf),
                    TagButton(pdf: pdf),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get progressWidget {
    final config = PdfConfig.fromPathSync(pdf.configPath);
    if (config.pageCount == -1) {
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
  }

  Widget get thumbnail {
    return PdfThumbnail(pdfPath: pdf.path, width: 130, height: 160);
  }
}
