import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class NovelChapterContentReader extends StatefulWidget {
  const new({super.key, required this.box, required this.item});
  final DuBox<NovelChapter> box;
  final NovelChapter item;

  @override
  State<NovelChapterContentReader> createState() =>
      _NovelChapterContentReaderState();
}

class _NovelChapterContentReaderState extends State<NovelChapterContentReader> {
  @override
  void initState() {
    init();
    super.initState();
  }

  List<String> contents = [];

  void init() async {
    final res = await widget.item.getContent<String>();
    if (res.isOk) {
      contents = res.unwrap().split('\n');
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reader')),
      body: _body(),
    );
  }

  Widget _body() {
    if (contents.isEmpty) {
      return Center(child: Text('Content Empty!'));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final text = contents[index];
          return Text(text, style: TextStyle(fontSize: 18));
        },
      ),
    );
  }
}
