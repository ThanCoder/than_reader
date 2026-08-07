import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_config.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/toc_drawer.dart';

// enum EpubReaderFetchingType { prevFetching, nextFetching, none }

class EpubReaderScreen extends StatefulWidget {
  final ReaderFile file;
  final EpubConfig config;
  final String cachePath;
  const EpubReaderScreen({
    super.key,
    required this.file,
    required this.config,
    required this.cachePath,
  });

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  void dispose() {
    epub.dispose();
    controller.dispose();
    super.dispose();
  }

  final epub = EpubEngine();
  // late final utils = EpubUtils(epub);
  List<EpubChapter> chapters = [];
  bool isOpened = false;
  int current = 0;
  int count = 0;
  Map<int, EpubContentItem> showItems = {};
  bool isLoading = false;
  List<EpubTocItem> toc = [];

  void init() async {
    setState(() {
      isLoading = true;
    });
    try {
      isOpened = await epub.open(widget.file.path);
      if (!isOpened) {
        if (!mounted) return;
        showTMessageDialogError(context, 'Opend Error');
        setState(() {
          isLoading = false;
        });
        return;
      }
      chapters = epub.chapters;
      count = chapters.length - 1;
      current = config.currentIndex;
      toc = epub.toc;

      if (chapters.isNotEmpty) {
        final res = await getCurrentChapterContent();
        showItems[current] = .new(
          index: current,
          content: res ?? 'Content Not found!',
        );
      }
      setState(() {
        isLoading = false;
      });

      await Future.delayed(Duration(milliseconds: 500));

      // go scroll
      if (config.currentScroll > 0) {
        // scroll ရှိနေလို့
        if (!controller.hasClients) return;
        controller.animateTo(
          config.currentScroll,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
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
    try {
      if (current > count) return null;

      // fetch engine
      final chapter = chapters[current];
      var html = await epub.getChapterContent(chapter);

      if (html == null) return null;
      final resolverList = <CachePathResolver>[];
      html = epub.resolveHtmlContent(
        html,
        onResolve: (tag, attribute, content) {
          final zipInnerPath = epub.getZipFullpath(content);
          final cacheFullpathPath = PathBuf(
            widget.cachePath,
          ).join(zipInnerPath).path;

          // print('tag: $tag - attribute: $attribute - content: $content');
          // print('zipInnerPath: $zipInnerPath');
          // print('cacheFullpathPath: $cacheFullpathPath');

          final resv = CachePathResolver(
            zipInnerPath: zipInnerPath,
            cacheFullpathPath: cacheFullpathPath,
          );
          resolverList.add(resv);
          return resv.cacheFullpathPath;
        },
      );
      await epub.resolveCaches(resolverList);

      return html;
    } catch (e) {
      if (!mounted) return null;
      showTMessageDialogError(context, e.toString());
      return null;
    }
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
        appBar: appbarWidget,
        drawer: tocDrawerWidget,
        onDrawerChanged: (isOpened) {
          // print('isOpened: $isOpened');
          if (isOpened) return;
          config = config.copyWith(
            lastDrawerListOffset: TocDrawer.recentListOffsetStatic,
            expansionTileState: TocDrawer.expansionTileStateStatic,
          );
        },
        body: bodyWidget,
      ),
    );
  }

  PreferredSizeWidget get appbarWidget {
    return AppBar(
      titleTextStyle: TextStyle(fontSize: 14),
      title: Row(
        children: [
          if (TPlatform.isDesktop)
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: existReader,
                icon: Icon(Icons.arrow_back),
              ),
            ),
          InkWell(
            onTap: showJumpIndexDialog,
            child: Text(
              'Count: $count',
              style: TextStyle(fontWeight: .bold, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget? get tocDrawerWidget {
    return TocDrawer(
      list: toc,
      expansionTileState: config.expansionTileState,
      recentListOffset: config.lastDrawerListOffset,
      currentSrc: currentTocSrc,
      onClicked: (src) async {
        final index = chapters.indexWhere((e) => e.href == src);

        if (index == -1) return;
        current = index;

        setState(() {
          isLoading = true;
        });
        try {
          if (showItems[current] == null) {
            final res = await getCurrentChapterContent();

            showItems[current] = .new(
              index: current,
              content: res ?? 'Content Not Found!',
            );
          }
        } catch (e) {
          debugPrint('[toc error]: $e');
        }
        setState(() {
          isLoading = false;
        });
        await Future.delayed(Duration(milliseconds: 400));
        if (!mounted) return;
        controller.jumpTo(0);
      },
    );
  }

  Widget get bodyWidget {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(child: navWidget),
        if (isLoading)
          SliverFillRemaining(child: Center(child: TLoaderRandom()))
        else
          SliverToBoxAdapter(child: resultWidget(showItems[current])),
        // SliverList.separated(
        //   itemCount: showItems.length,
        //   separatorBuilder: (context, index) => Divider(),
        //   itemBuilder: (context, index) => listItem(showItems[index]),
        // ),
        SliverToBoxAdapter(child: navWidget),
      ],
    );
  }

  Widget get navWidget {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: .center,
        children: [?prevChapterFetchWidget, Spacer(), ?nextChapterFetchWidget],
      ),
    );
  }

  Widget? get prevChapterFetchWidget {
    if (!isExistsPrev) return null;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 25, 124, 205),
        ),
        onPressed: goPrevChapter,
        icon: Icon(Icons.arrow_back_ios_rounded),
      ),
    );
  }

  Widget? get nextChapterFetchWidget {
    if (!isExistsNext || isLoading) return null;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 25, 124, 205),
        ),
        onPressed: goNextChapter,
        icon: Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }

  Widget? resultWidget(EpubContentItem? item) {
    if (item == null) return null;
    return Column(
      spacing: 4,
      children: [
        Text(
          'Index: ${item.index}',
          style: TextStyle(fontSize: 20, fontWeight: .bold),
        ),
        htmlWidget(item.content),
      ],
    );
  }

  Widget htmlWidget(String htmlData) {
    // print('content: $htmlData');
    return Html(
      data: htmlData,
      shrinkWrap: true,
      style: {'*': Style(fontSize: .large)},
      extensions: [
        TagExtension(
          tagsToExtend: {'img'},
          builder: (ext) {
            final attrs = ext.attributes;
            final src = attrs['src'];

            if (attrs.isEmpty || src == null || src.isEmpty) {
              return SizedBox.shrink();
            }

            return TImage(source: src);
          },
        ),
      ],
    );
  }

  // drawer
  String? get currentTocSrc {
    if (chapters.isEmpty) return null;
    final ch = chapters[current];
    return ch.href;
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
      isLoading = true;
    });
    try {
      current -= 1;
      if (showItems[current] == null) {
        final res = await getCurrentChapterContent();
        showItems[current] = .new(
          index: current,
          content: res ?? 'Content Not Found!',
        );
      }
    } catch (e) {
      debugPrint('[goPrevChapter]: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void goNextChapter() async {
    if (!isExistsNext) return;
    setState(() {
      isLoading = true;
    });
    try {
      current += 1;
      if (showItems[current] == null) {
        final res = await getCurrentChapterContent();

        showItems[current] = .new(
          index: current,
          content: res ?? 'Content Not Found!',
        );
      }
    } catch (e) {
      debugPrint('[goNextChapter]: $e');
    }
    setState(() {
      isLoading = false;
    });
    await Future.delayed(Duration(milliseconds: 400));
    if (!mounted) return;
    controller.animateTo(
      0,
      duration: Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }

  void existReader() {
    // print('${controller.offset}-${controller.position.maxScrollExtent}');
    Navigator.pop<EpubConfig>(
      context,
      config.copyWith(
        currentIndex: current,
        currentScroll: controller.offset,
        maxScroll: controller.position.maxScrollExtent,
      ),
    );
  }

  void showJumpIndexDialog() {
    showTReanmeDialog(
      context,
      text: current.toString(),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textInputType: .number,
      autofocus: true,
      submitText: 'Jump Page',
      onCheckIsError: (text) {
        final num = int.tryParse(text) ?? 0;
        if (num > count) {
          return 'Page Range `0-$count`';
        }
        return null;
      },
      onSubmit: (text) async {
        try {
          setState(() {
            isLoading = true;
          });
          current = int.parse(text);

          if (showItems[current] == null) {
            final html = await getCurrentChapterContent();

            showItems[current] = .new(
              index: current,
              content: html ?? 'Content Not Found!',
            );
          }
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        } catch (e) {
          if (!mounted) return;
          showTMessageDialogError(context, e.toString());
        }
      },
    );
  }
}

class EpubContentItem {
  final int index;
  final String content;
  const EpubContentItem({required this.index, required this.content});
}
