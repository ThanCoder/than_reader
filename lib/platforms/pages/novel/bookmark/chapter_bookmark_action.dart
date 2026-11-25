import 'package:flutter/widgets.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_config_controller.dart';
import 'package:than_reader/ui/build_context_x.dart';

class ChapterBookmarkAction extends StatefulWidget {
  const new({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<ChapterBookmarkAction> createState() => _ChapterBookmarkActionState();
}

class _ChapterBookmarkActionState extends State<ChapterBookmarkAction> {
  final con = NovelConfigController.instance;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return GestureDetector(
      onTap:widget.onTap,
      child: Container(
        padding: .symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: col.surfaceContainer,
          borderRadius: .circular(14),
        ),
        child: Text(
          'Bookmark',
          style: TextStyle(
            fontSize: 15,
            fontWeight: .w700,
            color: col.onSurface,
          ),
        ),
      ),
    );
  }
}
