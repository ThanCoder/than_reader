import 'dart:async';

import 'package:dual_store/dual_store.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/chapter_list_item_menu_sheet.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_content/novel_chapter_content_reader.dart';
import 'package:than_reader/platforms/pages/novel/forms/novel_chapter_form_page.dart';

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

  void goChapterFormPage({NovelChapter? editChapter}) async {
    await context.pushMaterialPageRoute(
      builder: (mainCtx) => NovelChapterFormPage(
        editChapter: editChapter,
        getLastChapter: (lang) {
          final list = groups[lang] ?? [];
          if (list.isNotEmpty) {
            return list.last;
          }
          return null;
        },
        getContentText: (lang, chNumber) async {
          final ch = await box.findOne(
            (e) => e.lang == lang && e.chapter == chNumber,
          );
          if (ch != null) {
            return await ch.getContentOrNull<String>();
          }
          return null;
        },
        onSaved: _addOrUpdate,
      ),
    );
  }

  Future<String?> _addOrUpdate(NovelChapter ch, String contentText) async {
    final lastCh = await box.findOne(
      (e) => e.chapter == ch.chapter && e.lang == ch.lang,
    );
    if (lastCh != null) {
      // update
      final res = await box.updateById(
        lastCh.generatedId,
        value: ch,
        contentWriter: TextCompressContentWriter(contentText),
      );
      if (res.isOk) {
        return 'Chapter: ${ch.chapter} Updated';
      }
    } else {
      // new
      final res = await box.add(
        ch,
        contentWriter: TextCompressContentWriter(contentText),
      );
      if (res.isOk) {
        return 'Chapter: ${ch.chapter} Added';
      }
    }
    return null;
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
    ChapterListItemMenuSheet.show(
      context,
      item,
      props: ChapterListItemMenuProps(
        onEdit: () => goChapterFormPage(editChapter: item),
        onCopyContentText: () async {
          final text = await item.getContentOrNull<String>();
          if (text == null) return;
          Clipboard.setData(.new(text: text));
        },
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
            children: [_header(), SizedBox(height: 16), _langsWidget()],
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
          onPressed: goChapterFormPage,
          icon: Icon(Icons.add_circle_outline_outlined),
        ),
        // SizedBox(width: 10),
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

  Widget _listWidget() {
    final list = groups[NovelChapterSliverList.lang] ?? [];
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: FilledButton.tonalIcon(
            onPressed: goChapterFormPage,
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
