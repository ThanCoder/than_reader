import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookGroupListItem extends StatelessWidget {
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
        child: Row(
          spacing: 5,
          children: [
            Icon(Icons.folder, size: 80),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: col.onSurface, fontWeight: .w600),
                  ),
                  Container(
                    padding: .symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      color: col.primary,
                      borderRadius: .circular(15),
                    ),
                    child: Text(
                      '${files.length}',
                      style: TextStyle(color: col.onPrimary, fontWeight: .w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
