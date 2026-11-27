import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/platforms/pages/novel/novel_config_controller.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class ChapterBookmarkToggle extends StatefulWidget {
  const new({super.key, required this.item});
  final NovelChapter item;

  @override
  State<ChapterBookmarkToggle> createState() => _ChapterBookmarkToggleState();
}

class _ChapterBookmarkToggleState extends State<ChapterBookmarkToggle> {
  final con = NovelConfigController.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: con.events.whereType<ChapterBookmarkChanged>(),
      builder: (context, asyncSnapshot) {
        final index = con.bookmarks.indexWhere(
          (e) => e.chapter == widget.item.chapter && e.lang == widget.item.lang,
        );
        final exists = index != -1;
        return IconButton(
          onPressed: () {
            if (exists) {
              con.removeBookmark(
                .new(
                  title: widget.item.title,
                  lang: widget.item.lang,
                  chapter: widget.item.chapter,
                ),
              );
              return;
            }
            con.addBookmark(
              .new(
                title: widget.item.title,
                lang: widget.item.lang,
                chapter: widget.item.chapter,
              ),
            );
          },
          icon: exists
              ? Icon(Icons.bookmark_remove_outlined, color: Colors.red)
              : Icon(Icons.bookmark_add_outlined, color: Colors.teal),
        );
      },
    );
  }
}
