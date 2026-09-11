import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookGroupGridItem extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.files,
    this.onClicked,
  });
  final String title;
  final List<ReaderFile> files;
  final void Function()? onClicked;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: InkWell(
        borderRadius: .circular(15),
        onTap: onClicked,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.folder, size: 80),
                Text(
                  title,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(color: col.onSurface, fontWeight: .w600),
                ),
              ],
            ),
            Positioned(
              right: 5,
              top: 5,
              child: Container(
                padding: .symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  color: col.primary,
                  borderRadius: .circular(15),
                ),
                child: Text(
                  files.length.toString().padLeft(2, '0'),
                  style: TextStyle(color: col.onPrimary, fontWeight: .w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
