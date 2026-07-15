import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/main_app/components/fav_toggle_button.dart';
import 'package:than_reader/main_app/components/pdf_config_progress_widget.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';
import 'package:than_reader/main_app/components/tag_button.dart';
import 'package:than_reader/main_app/components/tags_view.dart';

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // print('maxWidth: ${constraints.maxWidth}');
          final isMobile = constraints.maxWidth < 250;
          if (isMobile) {
            return Column(
              spacing: 6,
              children: [
                SizedBox(width: 100, height: 130, child: thumbnail),
                buildDetail,
              ],
            );
          }
          return Row(
            spacing: 4,
            children: [
              SizedBox(width: 100, height: 130, child: thumbnail),
              Expanded(child: buildDetail),
            ],
          );
        },
      ),
    );
  }

  Widget get buildDetail {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: .start,
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
        Row(
          children: [
            FavToggleButton(file: pdf),
            TagButton(pdf: pdf),
          ],
        ),
        TagsView(pdf: pdf),
      ],
    );
  }

  Widget get progressWidget {
    return PdfConfigProgressWidget(pdf: pdf);
  }

  Widget get thumbnail {
    return PdfThumbnail(pdfPath: pdf.path, width: 130, height: 160);
  }
}
