import 'package:material_ui/material_ui.dart';
import 'package:than_reader/ui/build_context_x.dart';

class NovelDescMenuSheetProps {
  final VoidCallback onEdit;
  final VoidCallback onCompact;
  final VoidCallback onNewChapter;
  final bool Function() showCompactTile;

  const new({
    required this.onEdit,
    required this.onCompact,
    required this.showCompactTile, required this.onNewChapter,
  });
}

class NovelDescMenuSheet extends StatefulWidget {
  const new({super.key, required this.props});
  final NovelDescMenuSheetProps props;

  @override
  State<NovelDescMenuSheet> createState() => _NovelDescMenuSheetState();

  static Future<void> show(
    BuildContext context,
    NovelDescMenuSheetProps props,
  ) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => NovelDescMenuSheet(props: props),
    );
  }
}

class _NovelDescMenuSheetState extends State<NovelDescMenuSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              tileColor: context.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              title: Text('Edit Description'),
              leading: Icon(Icons.edit_document),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                context.pop();
                widget.props.onEdit();
              },
            ),
            ListTile(
              tileColor: context.colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              title: Text('New Chapter'),
              leading: Icon(Icons.add_circle_outline),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                context.pop();
                widget.props.onNewChapter();
              },
            ),
            if (widget.props.showCompactTile())
              // if (db.state.deletedCount > 0)
              ListTile(
                tileColor: context.colorScheme.surfaceContainer,
                shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                title: Text('Databse Compact'),
                subtitle: Text('Databse Cleanup'),
                leading: Icon(Icons.clean_hands_outlined),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  context.pop();
                  widget.props.onCompact();
                },
              ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
