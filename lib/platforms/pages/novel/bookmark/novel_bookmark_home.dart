import 'package:dual_store/dual_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_config_controller.dart';
import 'package:than_reader/platforms/pages/novel/models/chapter_bookmark.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/routes.dart';
import 'package:than_reader/ui/build_context_x.dart';

class NovelBookmarkHome extends StatefulWidget {
  const new({super.key, required this.controller, required this.box});
  final NovelConfigController controller;
  final DuBox<NovelChapter> box;

  @override
  State<NovelBookmarkHome> createState() => _NovelBookmarkHomeState();
}

class _NovelBookmarkHomeState extends State<NovelBookmarkHome> {
  void goReader(ChapterBookmark book) async {
    final item = await widget.box.findOne(
      (e) => e.chapter == book.chapter && e.lang == book.lang,
    );
    if (!mounted) return;
    if (item == null) return;
    await goNovelChapterContentReader(context, box: widget.box, item: item);
    _lastItem = book;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmark')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 8),
            sliver: SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemCount: widget.controller.bookmarks.length,
              itemBuilder: (context, index) =>
                  _listItem(widget.controller.bookmarks[index]),
            ),
          ),
        ],
      ),
    );
  }

  ChapterBookmark? _lastItem;

  Widget _listItem(ChapterBookmark item) {
    final col = context.colorScheme;
    bool isLast = false;
    if (_lastItem != null) {
      isLast = _lastItem!.chapter == item.chapter;
    }

    return GestureDetector(
      // onSecondaryTap: () => showItemMenu(item),
      child: ListTile(
        tileColor: isLast ? col.primaryContainer : col.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: .circular(14)),
        title: Row(
          children: [
            Text(
              item.chapter.toString().replaceAll('.0', ''),
              style: TextStyle(fontSize: 18, fontWeight: .bold),
            ),
            SizedBox(width: 10),
            Container(
              padding: .symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: col.primary,
                borderRadius: .circular(14),
              ),
              child: Text(
                item.lang.label,
                style: TextStyle(color: col.onPrimary, fontSize: 12),
              ),
            ),
          ],
        ),
        subtitle: Text(item.title),
        // trailing: ChapterBookmarkToggle(item: item),
        onTap: () => goReader(item),
        // onLongPress: () => showItemMenu(item),
      ),
    );
  }
}
