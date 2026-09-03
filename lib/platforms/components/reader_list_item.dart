import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/util_ext.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';
import 'package:than_reader/platforms/components/reader_type_icon.dart';
import 'package:than_reader/platforms/pages/fav/fav_label.dart';

class ReaderListItem extends StatelessWidget {
  const new({
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
    return InkWell(
      borderRadius: .circular(15),
      mouseCursor: SystemMouseCursors.click,
      onTap: () => onClicked(file),
      onSecondaryTap: () => onRightClicked?.call(file),
      onLongPress: () => onRightClicked?.call(file),
      child: Container(
        padding: .all(6),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: Row(
          spacing: 5,
          children: [
            SizedBox(
              width: 80,
              height: 90,
              child: Stack(
                fit: .expand,
                children: [
                  ReaderCoverFile(file: file, borderRadius: .circular(6)),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: FavLabel(file: file, size: 20, padding: .all(2)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ReaderTypeIcon(file: file, size: 20),
                  ),
                ],
              ),
            ),
            Expanded(child: _content(col)),
          ],
        ),
      ),
    );
  }

  Widget _content(ColorScheme col) {
    return Column(
      children: [
        _menuList(
          col,
          icon: Icons.file_present_outlined,
          name: 'Name',
          title: file.name,
        ),
        _menuList(
          col,
          icon: Icons.date_range_outlined,
          name: 'Date',
          title: file.date.formatFullDate(),
        ),
        _menuList(
          col,
          icon: Icons.sd_card_outlined,
          name: 'Size',
          title: file.size.toFileSizeLabel(),
        ),
      ],
    );
  }

  Widget _menuList(
    ColorScheme col, {
    required IconData icon,
    required String name,
    required String title,
  }) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        Icon(icon, color: col.onSurfaceVariant, size: 20),
        Text(
          name,
          style: TextStyle(
            color: col.onSurface,
            fontWeight: .w700,
            fontSize: 14,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            textAlign: .right,
            overflow: .ellipsis,
            style: TextStyle(
              color: col.onSurface,
              fontWeight: .w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
