import 'dart:async';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/chapter_list_item_menu_sheet.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_controller.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_desc.dart';
import 'package:than_reader/platforms/pages/novel/routes.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_content/novel_chapter_content_reader.dart';
import 'package:than_reader/ui/index.dart';

class NovelChapterSliverList extends StatefulWidget {
  const new({super.key, required this.db, required this.desc});
  final DualStore db;
  final NovelDesc desc;

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
          _onSort(groups[val.lang] ?? []);
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
  final con = ControllerManager.read<NovelController>();

  Future<void> init({bool autoChooseLang = true}) async {
    groups.clear();
    final list = await box.getAll();
    list.sortChapter();
    for (var val in list) {
      groups.putIfAbsent(val.lang, () => []).add(val);
    }
    if (groups.isNotEmpty && autoChooseLang) {
      final firstLang = ChapterLaguage.fromVal(groups.keys.first.name);
      NovelChapterSliverList.lang = firstLang;
    }
    if (!mounted) return;
    setState(() {});
    _onSort(_currentChapterList);
  }

  void _goChapterFormPage({NovelChapter? editChapter}) async {
    await goChapterFormPage(
      context,
      box: box,
      lang: editChapter == null
          ? NovelChapterSliverList.lang
          : editChapter.lang,
      editChapter: editChapter,
    );
  }

  void goReader(NovelChapter item) async {
    await context.pushMaterialPageRoute(
      builder: (mainCtx) => NovelChapterContentReader(
        props: .new(
          lang: NovelChapterSliverList.lang,
          chapterNumber: item.chapter,
          getChapterBox: () => box,
          getChapter: (lang, chNumber) {
            return box.findOne((e) => e.chapter == chNumber && e.lang == lang);
          },
          getAvaliableLangs: (chNumber) async {
            final langs = <ChapterLaguage>{};
            final res = await box.find((e) => e.chapter == chNumber);
            for (var ch in res) {
              langs.add(ch.lang);
            }
            return langs.toList();
          },
        ),
      ),
    );
    con.cf.putAndWriteAll(
      _recentIdKey(item.generatedId, item.lang),
      item.generatedId,
    );
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
    con.cf.putAndWriteAll(
      _recentIdKey(item.generatedId, item.lang),
      item.generatedId,
    );
    if (!mounted) return;
    setState(() {});
  }

  List<NovelChapter> get _currentChapterList =>
      groups[NovelChapterSliverList.lang] ?? [];

  // sort
  var _numberSort = SortItem(
    id: 1,
    title: 'Number',
    isTrue: true,
    trueTitle: 'Small To Big',
    falseTitle: 'Big To Small',
  );

  void _onSort(List<NovelChapter> list) {
    if (_numberSort.isTrue) {
      list.sortChapter(smToBg: true);
      groups[NovelChapterSliverList.lang] = list;
    } else {
      List;
      list.sortChapter(smToBg: false);
      groups[NovelChapterSliverList.lang] = list;
    }

    if (!mounted) return;
    setState(() {});
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  String _recentIdKey(int itemId, ChapterLaguage lang) =>
      'recent-clicked-${lang.name}-${widget.desc.id}-$itemId';

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderDelegate(
            height: 124,
            child: SizedBox(
              height: 124,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _header(),
                    const SizedBox(height: 16),
                    _langHeader(),
                  ],
                ),
              ),
            ),
          ),
        ),
        _listWidget(),
      ],
    );
  }

  Row _header() {
    return Row(
      spacing: 10,
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
        IconButton(
          onPressed: () => init(autoChooseLang: false),
          icon: Icon(Icons.refresh_outlined),
        ),
        // SizedBox(width: 10),
        IconButton(
          onPressed: _goChapterFormPage,
          icon: Icon(Icons.add_circle_outline_outlined),
        ),
        SortProviderDialog.buttonWidget(
          value: _numberSort,
          list: [_numberSort],
          title: 'Sort Number',
          onApply: (item) {
            _numberSort = item;
            _onSort(_currentChapterList);
          },
        ),
        // SizedBox(width: 10),
      ],
    );
  }

  Widget _langHeader() => Padding(
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
        NovelChapterSliverList.lang = e;
        _onSort(_currentChapterList);
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
    final list = _currentChapterList;
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
    final isLast =
        con.cf.getInt(_recentIdKey(item.generatedId, item.lang)) ==
        item.generatedId;
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

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _HeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
