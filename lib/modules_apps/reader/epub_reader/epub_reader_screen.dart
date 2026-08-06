import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_engine_worker.dart';

class EpubReaderScreen extends StatefulWidget {
  final AppFile file;
  const EpubReaderScreen({super.key, required this.file});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    worker.dispose();
    super.dispose();
  }

  final worker = EpubEngineWorker.instance;
  List<String> hrefList = [];
  bool isOpened = false;
  int current = 0;
  int count = 0;
  List<EpubContentItem> showItems = [];
  bool isLoading = false;
  bool isFetching = false;

  void init() async {
    setState(() {
      isLoading = true;
    });
    try {
      hrefList = await worker.open(widget.file.path);
      count = hrefList.length;

      if (hrefList.isNotEmpty) {
        current = 1;
        addShowCurrentItem();
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

  @override
  Widget build(BuildContext context) {
    print('index: $current- count: $count');
    return Scaffold(
      appBar: AppBar(title: Text('Epub Reader')),
      body: isLoading
          ? Center(child: TLoaderRandom())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: !isExistsPrev
                      ? null
                      : fetchingLoadingWidget(
                          child: IconButton(
                            onPressed: goPrevChapter,
                            icon: Icon(Icons.arrow_back_ios_rounded),
                          ),
                        ),
                ),
                SliverList.separated(
                  itemCount: showItems.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => listItem(showItems[index]),
                ),
                SliverToBoxAdapter(
                  child: !isExistsNext
                      ? null
                      : fetchingLoadingWidget(
                          child: IconButton(
                            onPressed: goNextChapter,
                            icon: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget listItem(EpubContentItem item) {
    return Column(
      children: [
        Text('Index: ${item.index}'),
        Html(data: item.content),
      ],
    );
  }

  Widget fetchingLoadingWidget({required Widget child}) {
    if (isFetching) {
      return TLoader();
    }
    return child;
  }

  bool get isExistsNext => current < count;
  bool get isExistsPrev {
    if (showItems.isNotEmpty && showItems.first.index != 0) {
      return true;
    }
    return false;
  }

  Future<void> goPrevChapter() async {
    if (!isExistsPrev) return;
    current -= 1;
    setState(() {
      isFetching = true;
    });
    try {
      final item = hrefList[current];
      final res = await worker.getContent(item);
      showItems.insert(
        0,
        .new(index: current, content: res ?? 'Content Not Found!'),
      );
    } catch (e) {
      debugPrint('[goPrevChapter]: $e');
    }
    setState(() {
      isFetching = false;
    });
  }

  void goNextChapter() {
    if (!isExistsNext) return;
    current += 1;
    addShowCurrentItem();
  }

  Future<void> addShowCurrentItem() async {
    setState(() {
      isFetching = true;
    });
    try {
      final item = hrefList[current];
      final res = await worker.getContent(item);
      showItems.add(.new(index: current, content: res ?? 'Content Not Found!'));
    } catch (e) {
      debugPrint('[addShowCurrentItem]: $e');
    }
    setState(() {
      isFetching = false;
    });
  }
}

class EpubContentItem {
  final int index;
  final String content;
  EpubContentItem({required this.index, required this.content});
}
