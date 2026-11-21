import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/platforms/pages/novel/novel_content/keys.dart';
import 'package:than_reader/platforms/pages/novel/novel_content/novel_chapter_content_reader_sheet.dart';
import 'package:than_reader/platforms/pages/novel/routes.dart';

class NovelChapterContentReaderProps {
  const new({
    required this.lang,
    required this.chapterNumber,
    required this.getChapterBox,
    required this.getChapter,
    required this.getAvaliableLangs,
  });

  final ChapterLaguage lang;
  final double chapterNumber;
  final Future<NovelChapter?> Function(ChapterLaguage lang, double chNumber)
  getChapter;
  final Future<List<ChapterLaguage>> Function(double chNumber)
  getAvaliableLangs;
  final DuBox<NovelChapter> Function() getChapterBox;
}

class NovelChapterContentReader extends StatefulWidget {
  const new({super.key, required this.props});
  final NovelChapterContentReaderProps props;

  @override
  State<NovelChapterContentReader> createState() =>
      _NovelChapterContentReaderState();
}

class _NovelChapterContentReaderState extends State<NovelChapterContentReader> {
  final scrollCon = ScrollController();
  @override
  void initState() {
    _currentLang = widget.props.lang;
    _currentChNumber = widget.props.chapterNumber;
    super.initState();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(true);
    }
    // scrollCon.addListener(onScroll);
    _getCurrentContentText();
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.flutterUtils.toggleFullscreen(false);
    }
    scrollCon.dispose();
    super.dispose();
  }

  List<String> _contents = [];
  double _currentChNumber = 1;
  NovelChapter? _prev;
  NovelChapter? _next;
  late ChapterLaguage _currentLang;
  List<ChapterLaguage> _avaliableLangs = [];
  final cf = AppUtil.instance.config;

  Future<void> _getCurrentContentText() async {
    _contents.clear();
    setState(() {});
    final ch = await widget.props.getChapter(_currentLang, _currentChNumber);
    if (ch == null) return;
    final content = await ch.getContentOrNull<String>();
    if (content == null) return;
    _contents = content.split('\n');

    // search can change langs
    _avaliableLangs = await widget.props.getAvaliableLangs(_currentChNumber);
    // search prev,next
    _prev = await widget.props.getChapter(_currentLang, _currentChNumber - 1);
    _next = await widget.props.getChapter(_currentLang, _currentChNumber + 1);

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

  void _chooseCurrentLang(ChapterLaguage lang) {
    _currentLang = lang;
    _getCurrentContentText();
  }

  void showMenu() {
    NovelChapterContentReaderSheet.show(
      context,
      .new(
        hasContentText: _contents.isNotEmpty,
        onCopyContentText: () {
          Clipboard.setData(.new(text: _contents.join('\n')));
        },
        fontSize: cf.getDouble(novelContentFontSizeKey, novelContentFontSize),
        onFontSizeChanged: (fontSize) {
          cf.putAndWriteAll(novelContentFontSizeKey, fontSize);
        },
        goChapterForm: () async {
          final edit = await widget.props.getChapter(
            _currentLang,
            _currentChNumber,
          );
          if (!mounted) return;
          goChapterFormPage(
            context,
            box: widget.props.getChapterBox(),
            lang: _currentLang,
            editChapter: edit,
          );
        },
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      appBar: _contents.isNotEmpty ? null : AppBar(),
    );
  }

  Widget _body() {
    if (_contents.isEmpty) {
      return Center(child: Text('Content Empty!'));
    }
    return RefreshIndicator.adaptive(
      onRefresh: _getCurrentContentText,
      child: CustomScrollView(
        controller: scrollCon,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          _appbar(),
          SliverToBoxAdapter(child: prevChapterWidget),
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 15),
            sliver: SliverList.list(children: [_header()]),
          ),
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 15),
            sliver: _contentList(),
          ),
          SliverToBoxAdapter(child: nextChapterWidget),
          SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  SliverAppBar _appbar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: false,
      title: Text('Chapter: $_currentChNumber', style: TextStyle(fontSize: 18)),
      actions: [
        if (TPlatform.isDesktop)
          IconButton(
            onPressed: _getCurrentContentText,
            icon: Icon(Icons.refresh_outlined),
          ),
        if (TPlatform.isDesktop) SizedBox(width: 10),
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
            'Chapter: $_currentChNumber',
            style: TextStyle(fontWeight: .w600),
          ),
          SizedBox(height: 5),
          _avaliableLangWidget(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _avaliableLangWidget() {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: _avaliableLangs
          .map(
            (e) => GestureDetector(
              onTap: () => _chooseCurrentLang(e),
              child: Chip(
                avatar: e != _currentLang ? null : Icon(Icons.check_outlined),
                label: Text(e.label),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _contentList() {
    return StreamBuilder(
      stream: cf.stream.put.where((e) => e.key == novelContentFontSizeKey),
      builder: (context, asyncSnapshot) {
        return SliverList.builder(
          itemCount: _contents.length,
          itemBuilder: (context, index) => listItem(_contents[index]),
        );
      },
    );
  }

  Widget listItem(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: cf.getDouble(novelContentFontSizeKey, novelContentFontSize),
      ),
    );
  }

  Widget? get prevChapterWidget {
    if (_prev != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: .start,
          children: [
            FilledButton(
              onPressed: () {
                _currentChNumber = _prev!.chapter;
                _getCurrentContentText();
              },
              child: Text('Prev Chapter'),
            ),
          ],
        ),
      );
    }
    return null;
  }

  Widget? get nextChapterWidget {
    if (_next != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: .end,
          children: [
            FilledButton(
              onPressed: () {
                _currentChNumber = _next!.chapter;
                _getCurrentContentText();
              },
              child: Text('Next Chapter'),
            ),
          ],
        ),
      );
    }
    return null;
  }
}
