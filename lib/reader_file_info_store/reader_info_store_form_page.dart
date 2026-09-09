// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:than_reader/platforms/components/forms/input_text.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';

class ReaderInfoStoreFormPageData {
  final ReaderInfo info;
  final String desc;
  const ReaderInfoStoreFormPageData({required this.info, required this.desc});
}

class ReaderInfoStoreFormPage extends StatefulWidget {
  const new({super.key, required this.info, required this.des});
  final ReaderInfo info;
  final String des;

  @override
  State<ReaderInfoStoreFormPage> createState() =>
      _ReaderInfoStoreFormPageState();
}

class _ReaderInfoStoreFormPageState extends State<ReaderInfoStoreFormPage> {
  @override
  void initState() {
    info = widget.info;
    super.initState();
    init();
  }

  late ReaderInfo info;

  final titleCon = TextEditingController();
  final authorCon = TextEditingController();
  final translatorCon = TextEditingController();
  final coverUrlCon = TextEditingController();
  final descCon = TextEditingController();

  @override
  void dispose() {
    titleCon.dispose();
    authorCon.dispose();
    translatorCon.dispose();
    coverUrlCon.dispose();
    descCon.dispose();
    super.dispose();
  }

  void init() {
    titleCon.text = widget.info.title;
    authorCon.text = widget.info.author;
    translatorCon.text = widget.info.translator;
    coverUrlCon.text = widget.info.coverUrl;
    descCon.text = widget.des;
  }

  void saveAndClose() {
    context.pop<ReaderInfoStoreFormPageData>(
      .new(
        info: info.copyWith(
          title: titleCon.text,
          author: authorCon.text,
          coverUrl: coverUrlCon.text,
          translator: translatorCon.text,
        ),
        desc: descCon.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        saveAndClose();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reader Info Form'),
          actions: [
            IconButton(
              onPressed: saveAndClose,
              icon: Icon(Icons.save_as_outlined),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(8.0), child: _body()),
        ),
      ),
    );
  }

  Column _body() {
    return Column(
      spacing: 10,
      children: [
        SizedBox(height: 10),
        InputText(controller: titleCon, maxLines: 1, label: Text('Title')),
        InputText(controller: authorCon, maxLines: 1, label: Text('Author')),
        InputText(
          controller: translatorCon,
          maxLines: 1,
          label: Text('Translator'),
        ),
        InputText(
          controller: coverUrlCon,
          maxLines: 1,
          label: Text('Cover Url'),
        ),
        InputText(controller: descCon, label: Text('Description')),

        SizedBox(height: 50),
      ],
    );
  }
}
