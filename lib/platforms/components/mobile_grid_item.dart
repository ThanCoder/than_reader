import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';

class MobileGridItem extends StatelessWidget {
  const MobileGridItem({
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
    final col = context.colorScheme;
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
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Expanded(child: ReaderCoverFile(file: file)),
            SizedBox(height: 10),
            _content(col),
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
