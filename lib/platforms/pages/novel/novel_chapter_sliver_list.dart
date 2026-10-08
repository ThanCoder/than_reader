import 'dart:async';

import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/novel/forms/novel_chapter_edit_form_page.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_chapter_content_reader.dart';

class NovelChapterSliverList extends StatefulWidget {
  const new({super.key, required this.db});
  final DualStore db;

  @override
  State<NovelChapterSliverList> createState() => _NovelChapterSliverListState();
  static ChapterLaguage lang = .myanmar;
}

class _NovelChapterSliverListState extends State<NovelChapterSliverList> {
  StreamSubscription? _sub;
  @override
  void initState() {
    _sub = box.events.all.listen((event) {
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

  Future<void> init() async {
    groups.clear();
    final list = await box.getAll();
    list.sortChapter();
    for (var val in list) {
      groups.putIfAbsent(val.lang, () => []).add(val);
    }
    if (!mounted) return;
    setState(() {});
  }

  NovelChapter? _lastClickedItem;
  void goReader(NovelChapter item) async {
    await context.pushMaterialPageRoute(
      builder: (mainCtx) => NovelChapterContentReader(
        box: box,
        item: item,
        lang: NovelChapterSliverList.lang,
      ),
    );
    _lastClickedItem = item;
    if (!mounted) return;
    setState(() {});
  }

  void editChapter(NovelChapter item) async {
    final res = await context
        .pushMaterialPageRoute<NovelChapterEditFormPageRes>(
          builder: (mainCtx) =>
              NovelChapterEditFormPage(chapter: item, box: box),
        );
    if (res == null) return;
    final upRes = await box.update(
      item.generatedId,
      value: res.chapter,
      contentWriter: TextCompressContentWriter(res.contentText),
    );
    if (!mounted) return;

    if (upRes.isErr) {
      showErrorDialog(context, upRes.unwrapError());
      return;
    }
    init();
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
              tileColor: col.secondaryContainer,
              shape: RoundedRectangleBorder(borderRadius: .circular(14)),
              leading: Icon(Icons.edit_document),
              title: Text('Edit'),
              onTap: () async {
                context.pop();
                editChapter(item);
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
    final selected = e == NovelChapterSliverList.lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          NovelChapterSliverList.lang = e;
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
    final list = groups[NovelChapterSliverList.lang] ?? [];
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
