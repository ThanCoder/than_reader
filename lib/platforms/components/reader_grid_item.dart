import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/pages/fav/fav_label.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';

class ReaderGridItem extends StatelessWidget {
  const ReaderGridItem({
    super.key,
    required this.file,
    required this.onClicked,
    this.onRightClicked,
  });
  final ReaderFile file;
  final void Function(ReaderFile file) onClicked;
  final void Function(ReaderFile file)? onRightClicked;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return Container(
      padding: .all(8),
      decoration: BoxDecoration(
        borderRadius: .circular(15),
        color: col.surfaceContainer,
      ),
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () => onClicked(file),
        onSecondaryTap: () => onRightClicked?.call(file),
        onLongPress: () => onRightClicked?.call(file),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: .center,
              children: [
                Expanded(child: ReaderCoverFile(file: file)),
                SizedBox(height: 10),
                _content(col),
              ],
            ),
            Positioned(left: 0, top: 0, child: FavLabel(file: file)),
          ],
        ),
      ),
    );
  }

  Widget _content(ColorScheme col) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        Text(
          file.name,
          maxLines: 2,
          overflow: .ellipsis,
          style: TextStyle(color: col.onSurface),
        ),
      ],
    );
  }
}
