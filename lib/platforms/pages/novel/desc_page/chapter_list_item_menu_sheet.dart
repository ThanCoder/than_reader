import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/ui/components/scrollable_columm.dart';
import 'package:than_reader/ui/index.dart';

class ChapterListItemMenuProps {
  const new({required this.onEdit, required this.onCopyContentText});

  final VoidCallback onEdit;
  final VoidCallback onCopyContentText;
}

class ChapterListItemMenuSheet extends StatefulWidget {
  const new({super.key, required this.chapter, required this.props});
  final NovelChapter chapter;
  final ChapterListItemMenuProps props;

  @override
  State<ChapterListItemMenuSheet> createState() =>
      _ChapterListItemMenuSheetState();

  static Future<void> show(
    BuildContext context,
    NovelChapter chapter, {
    required ChapterListItemMenuProps props,
  }) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) =>
          ChapterListItemMenuSheet(chapter: chapter, props: props),
    );
  }
}

class _ChapterListItemMenuSheetState extends State<ChapterListItemMenuSheet> {
  ColorScheme get col => context.colorScheme;

  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      spacing: 10,
      children: [
        ListTile(
          tileColor: col.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          leading: Icon(Icons.edit_document),
          title: Text('Edit'),
          onTap: () async {
            context.pop();
            widget.props.onEdit();
          },
        ),
        ListTile(
          tileColor: col.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          leading: Icon(Icons.copy_all_outlined),
          title: Text('Copy All Content Text'),
          onTap: () async {
            context.pop();
            widget.props.onCopyContentText();
          },
        ),
        ListTile(
          tileColor: col.errorContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          leading: Icon(Icons.delete_forever_outlined),
          title: Text('Delete'),
          onTap: () async {
            context.pop();
            final conf = await showConfirmDialog(
              context,
              '`${widget.chapter.chapter}` Want To Delete?',
              closeText: 'No',
              confirmText: 'Delete Forever',
              confirmColor: col.error,
              confirmForegroundColor: col.onError,
            );
            if (!conf) return;
            await widget.chapter.delete();
          },
        ),
        SizedBox(height: 80),
      ],
    );
  }
}
