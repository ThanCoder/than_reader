import 'dart:io';

import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class NovelChapterContentReader extends StatefulWidget {
  const new({
    super.key,
    required this.box,
    required this.item,
    required this.lang,
  });
  final DuBox<NovelChapter> box;
  final NovelChapter item;
  final ChapterLaguage lang;

  @override
  State<NovelChapterContentReader> createState() =>
      _NovelChapterContentReaderState();
}

class _NovelChapterContentReaderState extends State<NovelChapterContentReader> {
  final scrollCon = ScrollController();
  @override
  void initState() {
    current = widget.item;
    lang = widget.lang;
    init(current);
    super.initState();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(true);
    }
    // scrollCon.addListener(onScroll);
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(false);
    }
    scrollCon.dispose();
    super.dispose();
  }

  List<String> contents = [];
  late NovelChapter current;
  NovelChapter? prev;
  NovelChapter? next;
  late ChapterLaguage lang;

  void init(NovelChapter item) async {
    contents.clear();
    setState(() {});
    final res = await item.getContent<String>();
    if (!mounted) return;
    if (res.isErr) {
      showErrorDialog(context, res.unwrapError());
      return;
    }
    contents = res.unwrap().split('\n');
    current = item;
    prev = await fetchChapter(item.chapter - 1);
    next = await fetchChapter(item.chapter + 1);
    if (!mounted) return;
    setState(() {});
    if (scrollCon.hasClients) {
      if (scrollCon.position.pixels == 0) return;
      // await Future.delayed(Duration(seconds: 700));
      // scrollCon.jumpTo(0);
      scrollCon.animateTo(
        0,
        duration: Duration(milliseconds: 900),
        curve: Curves.linear,
      );
    }
  }

  Future<NovelChapter?> fetchChapter(double chNumber) async {
    // return await widget.box.findOne(
    //   (val) => val.chapter == chNumber && val.lang == lang,
    // );
    await for (var val in widget.box.streamFindOne(
      (val) => val.chapter == chNumber && val.lang == lang,
    )) {
      return val;
    }

    return null;
  }

  void showMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            if (contents.isNotEmpty)
              ListTile(
                leading: Icon(Icons.copy_all_outlined),
                title: Text('Copy Content'),
                onTap: () {
                  context.pop();
                  Clipboard.setData(.new(text: contents.join('\n')));
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
    return Scaffold(body: _body());
  }

  Widget _body() {
    if (contents.isEmpty) {
      return Center(child: Text('Content Empty!'));
    }
    return CustomScrollView(
      controller: scrollCon,
      slivers: [
        _appbar(),
        SliverToBoxAdapter(child: prevChapterWidget),
        SliverPadding(
          padding: .symmetric(vertical: 10, horizontal: 15),
          sliver: SliverList.list(children: [_header()]),
        ),
        SliverPadding(
          padding: .symmetric(vertical: 10, horizontal: 15),
          sliver: SliverList.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) => listItem(contents[index]),
          ),
        ),
        SliverToBoxAdapter(child: nextChapterWidget),
        SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  SliverAppBar _appbar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: false,
      title: Text(
        'Chapter: ${current.chapter}',
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        IconButton(onPressed: showMenu, icon: Icon(Icons.more_vert_outlined)),
      ],
    );
  }

  Container _header() {
    return Container(
      padding: .symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(14),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Chapter: ${current.chapter}',
            style: TextStyle(fontWeight: .w600),
          ),
          SizedBox(height: 5),
          Text('Language: ${lang.label}', style: TextStyle(fontWeight: .w600)),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget listItem(String text) {
    return Text(text, style: TextStyle(fontSize: 18));
  }

  Widget? get prevChapterWidget {
    if (prev != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: .start,
          children: [
            FilledButton(
              onPressed: () => init(prev!),
              child: Text('Prev Chapter'),
            ),
          ],
        ),
      );
    }
    return null;
  }

  Widget? get nextChapterWidget {
    if (next != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: .end,
          children: [
            FilledButton(
              onPressed: () => init(next!),
              child: Text('Next Chapter'),
            ),
          ],
        ),
      );
    }
    return null;
  }
}
