import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/reader_type_icon.dart';

class ShareGridItem extends StatelessWidget {
  const ShareGridItem({
    super.key,
    required this.file,
    required this.host,
    required this.onClicked,
  });
  final ReaderFile file;
  final String host;
  final void Function(ReaderFile file) onClicked;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      borderRadius: .circular(15),
      onTap: () {
        onClicked(file);
      },
      child: Container(
        padding: .all(8),
        decoration: BoxDecoration(borderRadius: .circular(15)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: .circular(5),
                child: Image.network(
                  'http://$host/api/thumbnail/${file.configId}',
                  fit: .cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      'Error: $error',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(right: 0, top: 0, child: ReaderTypeIcon(file: file)),
            Positioned(left: 0, right: 0, bottom: 0, child: _content(col)),
          ],
        ),
      ),
    );
  }

  Widget _content(ColorScheme col) {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: col.surfaceContainer.withValues(alpha: .65),
      ),
      child: Text(
        file.name,
        maxLines: 2,
        overflow: .ellipsis,
        textAlign: .center,
        style: TextStyle(color: col.onSurface, fontSize: 14, fontWeight: .w600),
      ),
    );
  }
}
