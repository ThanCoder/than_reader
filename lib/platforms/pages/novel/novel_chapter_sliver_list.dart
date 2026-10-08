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
  Map<ChapterLaguage, List<NovelChapter>> groups = {};
  ChapterLaguage lang = .myanmar;

  Future<void> init() async {
    final list = await box.getAll();
    for (var val in list) {
      groups.putIfAbsent(val.lang, () => []).add(val);
    }
    list.sortChapter();
    if (!mounted) return;
    setState(() {});
  }

  NovelChapter? _lastClickedItem;
  void goReader(NovelChapter item) async {
    await context.pushMaterialPageRoute(
      builder: (mainCtx) =>
          NovelChapterContentReader(box: box, item: item, lang: lang),
    );
    _lastClickedItem = item;
    if (!mounted) return;
    setState(() {});
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
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: .symmetric(vertical: 10, horizontal: 15),
          sliver: SliverList.list(
            children: [
              Text(
                'Chapters',
                style: TextStyle(
                  fontWeight: .w700,
                  fontSize: 18,
                  color: col.onSurface,
                ),
              ),
              SizedBox(height: 16),
              if (groups.isEmpty)
                RefreshButton(text: Text('List Empty'), onClicked: init),

              _langsWidget(),
            ],
          ),
        ),

        _listWidget(),
      ],
    );
  }

  Widget _langsWidget() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Wrap(
      spacing: 5,
      runSpacing: 5,
      children: groups.keys.map((e) => _langItem(e)).toList(),
    ),
  );

  Widget _langItem(ChapterLaguage e) {
    final selected = e == lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          lang = e;
        });
      },
      child: Container(
        padding: .symmetric(vertical: 2, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? col.primary : col.surfaceContainer,
          borderRadius: .circular(14),
        ),
        child: Text(
          e.label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: .w700,
            color: selected ? col.onPrimary : col.onSurface,
          ),
        ),
      ),
    );
  }

  SliverList _listWidget() {
    final list = groups[lang] ?? [];
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
    final isLast = _lastClickedItem?.generatedId == item.generatedId;
    return GestureDetector(
      onSecondaryTap: () => showItemMenu(item),
      child: ListTile(
        tileColor: isLast ? col.primaryContainer : col.surfaceContainer,
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
