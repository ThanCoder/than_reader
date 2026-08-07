import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/fav_toggle_button.dart';
import 'package:than_reader/main_app/components/reader_file_config_progress_widget.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';

class PdfGridItem extends StatelessWidget {
  final ReaderFile pdf;
  final void Function(ReaderFile pdf)? onClicked;
  final void Function(ReaderFile pdf)? onMenuClicked;
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
                Positioned(top: 0, right: 0, child: bookTypeIconWidget),
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

  Widget get bookTypeIconWidget {
    if (pdf.type == .epub) {
      return SvgPicture.asset(
        'assets/svg/epub-svgrepo-com.svg',
        width: 30,
        height: 30,
      );
    }
    if (pdf.type == .pdf) {
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

  Widget get progressWidget {
    return ReaderFileConfigProgressWidget(pdf: pdf);
  }

  Widget get thumbnail {
    return PdfThumbnail(file: pdf, width: 180, height: 200);
  }
}
