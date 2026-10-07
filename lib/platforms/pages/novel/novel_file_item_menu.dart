import 'package:flutter/material.dart';
import 'package:than_reader/platforms/pages/novel/novel_file.dart';

class NovelFileItemMenu extends StatefulWidget {
  const new({super.key, required this.file});
  final NovelFile file;

  @override
  State<NovelFileItemMenu> createState() => _NovelFileItemMenuState();

  static Future<void> show(
    BuildContext context, {
    required NovelFile file,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => NovelFileItemMenu(file: file),
    );
  }
}

class _NovelFileItemMenuState extends State<NovelFileItemMenu> {
  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              tileColor: col.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              leading: Icon(Icons.edit_document),
              title: Text('Rename'),
              onTap: () {},
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              tileColor: col.errorContainer,
              leading: Icon(
                Icons.delete_forever_outlined,
                color: col.onErrorContainer,
              ),
              title: Text('Delete'),
              onTap: () {},
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
