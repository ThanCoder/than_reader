import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_config.dart';

enum EpubReaderFetchingType { prevFetching, nextFetching, none }

class EpubReaderScreen extends StatefulWidget {
  final AppFile file;
  final EpubConfig config;
  const EpubReaderScreen({super.key, required this.file, required this.config});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  late EpubConfig config;
  final controller = ScrollController();
  @override
  void initState() {
    config = widget.config;
    super.initState();
    init();
  }

  @override
  void dispose() {
    epub.dispose();
    controller.dispose();
    super.dispose();
  }

  final epub = EpubEngine();
  List<EpubChapter> chapters = [];
  bool isOpened = false;
  int current = 0;
  int count = 0;
  Map<int, EpubContentItem> showItems = {};
  bool isLoading = false;
  EpubReaderFetchingType fetchingType = .none;

  void init() async {
    setState(() {
      isLoading = true;
    });
    try {
      isOpened = await epub.open(widget.file.path);
      chapters = epub.chapters;
      count = chapters.length;
      current = config.currentIndex;

      if (chapters.isNotEmpty) {
        current = 1;
        final res = await getCurrentChapterContent();
        showItems[current] = .new(
          index: current,
          content: res ?? 'Content Not found!',
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('[_EpubReaderScreenState:init]: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  Future<String?> getCurrentChapterContent() async {
    if (current > count) return null;
    final chapter = chapters[current];
    return await epub.getChapterContent(chapter);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        existReader();
      },
      child: Scaffold(
        appBar: AppBar(
          title: IconButton(
            onPressed: existReader,
            icon: Icon(Icons.arrow_back),
          ),
        ),
        drawer: Drawer(),
        body: bodyWidget,
      ),
    );
  }

  Widget get bodyWidget {
    if (isLoading) {
      return Center(child: TLoaderRandom());
    }
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(child: prevChapterFetchWidget),
        SliverToBoxAdapter(child: listItem(showItems[current])),
        // SliverList.separated(
        //   itemCount: showItems.length,
        //   separatorBuilder: (context, index) => Divider(),
        //   itemBuilder: (context, index) => listItem(showItems[index]),
        // ),
        SliverToBoxAdapter(child: nextChapterFetchWidget),
      ],
    );
  }

  Widget? get prevChapterFetchWidget {
    if (!isExistsPrev || isLoading) return null;
    if (fetchingType == .prevFetching) {
      return TLoader();
    }
    return IconButton(
      onPressed: goPrevChapter,
      icon: Icon(Icons.arrow_back_ios_rounded),
    );
  }

  Widget? get nextChapterFetchWidget {
    if (!isExistsNext || isLoading) return null;
    if (fetchingType == .nextFetching) {
      return TLoader();
    }
    return IconButton(
      onPressed: goNextChapter,
      icon: Icon(Icons.arrow_forward_ios_outlined),
    );
  }

  Widget? listItem(EpubContentItem? item) {
    if (item == null) return null;
    return Column(
      children: [
        Text('Index: ${item.index}'),
        Html(
          data: item.content,
          shrinkWrap: true,
          style: {'*': Style(fontSize: .large)},
        ),
      ],
    );
  }

  bool get isExistsNext => current < count;
  bool get isExistsPrev {
    if (current - 1 != -1) {
      return true;
    }
    return false;
  }

  Future<void> goPrevChapter() async {
    if (!isExistsPrev) return;
    setState(() {
      fetchingType = .prevFetching;
    });
    try {
      final res = await getCurrentChapterContent();

      showItems[current - 1] = .new(
        index: current,
        content: res ?? 'Content Not Found!',
      );
      current -= 1;
    } catch (e) {
      debugPrint('[goPrevChapter]: $e');
    }
    setState(() {
      fetchingType = .none;
    });
  }

  void goNextChapter() async {
    if (!isExistsNext) return;
    setState(() {
      fetchingType = .nextFetching;
    });
    try {
      final res = await getCurrentChapterContent();

      showItems[current + 1] = .new(
        index: current,
        content: res ?? 'Content Not Found!',
      );
      current += 1;
    } catch (e) {
      debugPrint('[goNextChapter]: $e');
    }
    setState(() {
      fetchingType = .none;
    });
    await Future.delayed(Duration(milliseconds: 400));
    if (!mounted) return;
    controller.jumpTo(0);
  }

  void existReader() {
    Navigator.pop<EpubConfig>(context, config.copyWith(currentIndex: current));
  }
}

class EpubContentItem {
  final int index;
  final String content;
  const EpubContentItem({required this.index, required this.content});
}
