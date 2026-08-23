import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/util_ext.dart';
import 'package:than_reader/platforms/pages/fav/fav_label.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';

class InfoMenu extends StatefulWidget {
  const InfoMenu({super.key, required this.file});

  final ReaderFile file;

  @override
  State<InfoMenu> createState() => _InfoMenuState();
}

class _InfoMenuState extends State<InfoMenu> {
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: .all(8),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(15),
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .end,
              crossAxisAlignment: .start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  margin: .symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: .circular(15),
                    color: col.surfaceContainerHighest,
                    boxShadow: [
                      .new(
                        color: col.primaryContainer.withValues(alpha: .85),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: .circular(20),
                    child: ReaderCoverFile(file: widget.file),
                  ),
                ),
                Spacer(),
                // fav label
                FavLabel(file: widget.file),
              ],
            ),

            _menuTile(widget.file.name, icon: Icons.title_outlined),
            _menuTile(
              widget.file.size.fileSizeLabel(),
              icon: Icons.sd_card_outlined,
            ),
            _menuTile(
              widget.file.date.formatFullDate(),
              icon: Icons.date_range_outlined,
            ),
            _menuTile(widget.file.type.label, icon: Icons.category_outlined),
            _menuTile(widget.file.configId, icon: Icons.key),
            _menuTile(widget.file.parentPath, icon: Icons.folder_outlined),
            _menuTile(widget.file.path, icon: Icons.folder_outlined),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(String title, {required IconData icon}) {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: .circular(15),
        color: col.surfaceContainerHigh,
      ),
      child: Row(
        spacing: 15,
        children: [
          Icon(icon),
          Expanded(child: Text(title)),
        ],
      ),
    );
  }
}
