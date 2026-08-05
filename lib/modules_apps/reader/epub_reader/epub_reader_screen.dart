import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/app_file.dart';

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
    super.dispose();
  }

  final eng = EpubEngine();
  List<BookChapterItem> list = [];
  bool isOpened = false;
  int current = 0;
  int count = 0;
  String content = '';

  void init() {
    try {
      if (!isOpened) {
        eng.open(widget.file.path);
        isOpened = true;
      }

      list = eng.getChapters();
      count = list.length;

      if (list.isNotEmpty) {
        final item = list[current];
        final res = eng.getChapterContent(item);
        print(list.first);
        print('content: $res');
        content = res ?? 'Content Not Found!\n${item.path}';
      }
      setState(() {});
    } catch (e) {
      debugPrint('[_EpubReaderScreenState:init]: $e');
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Epub Reader')),
      body: Center(child: Text(content)),
    );
  }
}
