import 'dart:async';

import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_chapter_content_reader.dart';

class NovelChapterSliverList extends StatefulWidget {
  const new({super.key, required this.db});
  final DualStore db;

  @override
  State<NovelChapterSliverList> createState() => _NovelChapterSliverListState();
}

class _NovelChapterSliverListState extends State<NovelChapterSliverList> {
  StreamSubscription? _sub;
  @override
  void initState() {
    _sub = box.events.add.listen((event) {
      init();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => init());

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  DuBox<NovelChapter> get box => widget.db.getBox<NovelChapter>();
  List<NovelChapter> list = [];
  ChapterLaguage lang = .myanmar;

  Future<void> init() async {
    list = await box.getAll();
    // list = list.where((e) => e.lang == lang).toList();
    list.sortChapter();
    if (!mounted) return;
    setState(() {});
  }

  void goReader(NovelChapter item) {
    context.pushMaterialPageRoute(
      builder: (mainCtx) => NovelChapterContentReader(box: box, item: item),
    );
  }

  void showItemMenu(NovelChapter item) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              leading: Icon(Icons.delete_forever_outlined),
              title: Text('Delete'),
              onTap: () async {
                context.pop();
                final conf = await showConfirmDialog(
                  context,
                  'Want To Delete?',
                  closeText: 'No',
                  confirmText: 'Delete Forever',
                  confirmColor: col.error,
                  confirmForegroundColor: col.onError,
                );
                if (!conf) return;
                await item.delete();
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: RefreshButton(text: Text('List Empty'), onClicked: init),
      );
    }
    // print(list);
    return SliverList.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return listItem(item);
      },
    );
  }

  Widget listItem(NovelChapter item) {
    return GestureDetector(
      onSecondaryTap: () => showItemMenu(item),
      child: ListTile(
        tileColor: col.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: .circular(14)),
        title: Row(
          children: [
            Text(item.chapter.toString()),
            SizedBox(width: 10),
            Container(
              padding: .symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: col.primary,
                borderRadius: .circular(14),
              ),
              child: Text(
                item.lang.label,
                style: TextStyle(color: col.onPrimary),
              ),
            ),
          ],
        ),
        subtitle: Text(item.title),
        onTap: () => goReader(item),
        onLongPress: () => showItemMenu(item),
      ),
    );
  }
}
