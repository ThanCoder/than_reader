import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/main_app/components/fav_toggle_button.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';

class PdfGridItem extends StatelessWidget {
  final PdfFile pdf;
  final void Function(PdfFile pdf)? onClicked;
  final void Function(PdfFile pdf)? onMenuClicked;
  const PdfGridItem({
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
                // fav
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: FavToggleButton(file: pdf),
                  ),
                ),
                // progress
                Positioned(left: 0, right: 0, bottom: 0, child: progressWidget),
              ],
            ),
          ),
          Text(
            pdf.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
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
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: LinearProgressIndicator(value: config.page / config.pageCount),
    );
  }

  Widget get thumbnail {
    return PdfThumbnail(pdfPath: pdf.path, width: 180, height: 200);
  }
}
