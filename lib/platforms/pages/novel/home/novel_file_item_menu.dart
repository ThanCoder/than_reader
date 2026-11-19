import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';
import 'package:than_reader/ui/build_context_x.dart';

class NovelFileItemMenuProps {
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const NovelFileItemMenuProps({
    required this.onRename,
    required this.onDelete,
  });
}

class NovelFileItemMenu extends StatefulWidget {
  const new({super.key, required this.file, required this.props});
  final NovelFile file;
  final NovelFileItemMenuProps props;

  @override
  State<NovelFileItemMenu> createState() => _NovelFileItemMenuState();

  static Future<void> show(
    BuildContext context, {
    required NovelFile file,
    required NovelFileItemMenuProps props,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => NovelFileItemMenu(file: file, props: props),
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
              onTap: () {
                context.pop();
                widget.props.onRename();
              },
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              tileColor: col.errorContainer,
              leading: Icon(
                Icons.delete_forever_outlined,
                color: col.onErrorContainer,
              ),
              title: Text('Delete'),
              onTap: () {
                context.pop();
                widget.props.onDelete();
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
