import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';

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
          SizedBox(width: 130, height: 160, child: thumbnail),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(pdf.name),
                Text('Size: ${pdf.size.toFileSizeLabel()}'),
                Text('Date: ${pdf.date.toDetailedAgeLabel()}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get thumbnail {
    return PdfThumbnail(pdfPath: pdf.path, width: 130, height: 160);
  }
}
