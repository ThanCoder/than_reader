import 'dart:async';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/chapter_list_item_menu_sheet.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/routes.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_content/novel_chapter_content_reader.dart';

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
      if (event is BoxAdded) {
        final val = event.value;
        if (val is NovelChapter) {
          groups.putIfAbsent(val.lang, () => []).add(val);
          if (!mounted) return;
          setState(() {});
        }
      }
      if (event is BoxUpdated) {
        final val = event.value;
        if (val is NovelChapter) {
          for (var m in groups.entries) {
            final k = m.key;
            final listId = m.value.indexWhere(
              (e) => e.generatedId == val.generatedId,
            );
            if (listId == -1) return;
            final res = groups[k]!;
            res[listId] = val;
            groups[k] = res;
          }
        }
        if (!mounted) return;
        setState(() {});
      }
      if (event is BoxDeleted) {
        final id = event.id;
        for (var m in groups.entries) {
          final k = m.key;
          final res = m.value.where((e) => e.generatedId != id).toList();
          groups[k] = res;
        }
        if (!mounted) return;
        setState(() {});
      }
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
  final Map<ChapterLaguage, List<NovelChapter>> groups = {};

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

  void _goChapterFormPage({NovelChapter? editChapter}) async {
    await goChapterFormPage(context, box: box);
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

  void showItemMenu(NovelChapter item) async {
    await ChapterListItemMenuSheet.show(
      context,
      item,
      props: ChapterListItemMenuProps(
        onEdit: () => _goChapterFormPage(editChapter: item),
        onCopyContentText: () async {
          final text = await item.getContentOrNull<String>();
          if (text == null) return;
          Clipboard.setData(.new(text: text));
        },
      ),
    );
    _lastClickedItem = item;
    if (!mounted) return;
    setState(() {});
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: .symmetric(vertical: 10, horizontal: 15),
          sliver: SliverList.list(
            children: [_header(), SizedBox(height: 16), _subHeader()],
          ),
        ),

        _listWidget(),
      ],
    );
  }

  Row _header() {
    return Row(
      children: [
        Text(
          'Chapters',
          style: TextStyle(
            fontWeight: .w700,
            fontSize: 18,
            color: col.onSurface,
          ),
        ),
        Spacer(),
        IconButton(onPressed: init, icon: Icon(Icons.refresh_outlined)),
        SizedBox(width: 10),
        IconButton(
          onPressed: _goChapterFormPage,
          icon: Icon(Icons.add_circle_outline_outlined),
        ),
        // SizedBox(width: 10),
      ],
    );
  }

  Widget _subHeader() => Padding(
    padding: .symmetric(vertical: 8),
    child: Wrap(
      spacing: 5,
      runSpacing: 5,
      children: groups.keys.map((e) => _langItem(e)).toList(),
    ),
  );

  Widget _langItem(ChapterLaguage e, {double fontSize = 17}) {
    final selected = e == NovelChapterSliverList.lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          NovelChapterSliverList.lang = e;
        });
      },
      child: Container(
        padding: .symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? col.primary : col.surfaceContainer,
          borderRadius: .circular(14),
        ),
        child: Text(
          e.label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: .w700,
            color: selected ? col.onPrimary : col.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _listWidget() {
    final list = groups[NovelChapterSliverList.lang] ?? [];
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: FilledButton.tonalIcon(
            onPressed: _goChapterFormPage,
            label: Text('New Chapter'),
          ),
        ),
      );
    }
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
        subtitle: Column(
          crossAxisAlignment: .start,
          spacing: 4,
          children: [Text(item.title), Text(item.date.formatDate())],
        ),
        onTap: () => goReader(item),
        onLongPress: () => showItemMenu(item),
      ),
    );
  }
}
