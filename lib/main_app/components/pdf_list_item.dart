import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/fav_toggle_button.dart';
import 'package:than_reader/main_app/components/reader_file_config_progress_widget.dart';
import 'package:than_reader/main_app/components/pdf_thumbnail.dart';
import 'package:than_reader/main_app/components/tag_button.dart';
import 'package:than_reader/main_app/components/tags_view.dart';

class PdfListItem extends StatelessWidget {
  final ReaderFile pdf;
  final void Function(ReaderFile pdf)? onClicked;
  final void Function(ReaderFile pdf)? onMenuClicked;
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
    return Stack(
      children: [
        Positioned.fill(
          child: PdfThumbnail(file: pdf, width: 130, height: 160),
        ),
        Positioned(top: 0, right: 0, child: bookTypeIconWidget),
      ],
    );
  }
}
