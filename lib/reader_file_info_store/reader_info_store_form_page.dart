// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/prompt_alert_dialog.dart';

import 'package:than_reader/platforms/components/forms/input_text.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';

class ReaderInfoStoreFormPageData {
  final ReaderInfo info;
  final String desc;
  const ReaderInfoStoreFormPageData({required this.info, required this.desc});
}

class ReaderInfoStoreFormPage extends StatefulWidget {
  const new({super.key, required this.info, required this.desc});
  final ReaderInfo info;
  final String desc;

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
    descCon.text = widget.desc;
  }

  void saveAndClose() async {
    final conf = await showConfirmDialog(
      context,
      barrierDismissible: false,
      'Want to Save?',
      confirmText: 'Save',
      closeText: 'No',
    );
    if (!mounted) return;
    if (!conf) {
      context.pop();
      return;
    }
    context.pop<ReaderInfoStoreFormPageData>(
      .new(
        info: info.copyWith(
          title: titleCon.text,
          author: authorCon.text,
          coverUrl: coverUrlCon.text,
          translator: translatorCon.text,
          date: .now(),
        ),
        desc: descCon.text,
      ),
    );
  }

  ColorScheme get col => Theme.of(context).colorScheme;
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
              style: IconButton.styleFrom(
                backgroundColor: col.surfaceContainerHighest,
                foregroundColor: col.onSurfaceVariant,
              ),
              onPressed: saveAndClose,
              icon: Icon(Icons.save_as_outlined),
            ),
            SizedBox(width: 10),
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
      crossAxisAlignment: .start,
      children: [
        SizedBox(height: 10),
        _bookIdWidget,
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

        _urlWidget,
        _genresWidget,
        _tagsWidget,
        SizedBox(height: 50),
      ],
    );
  }

  Widget get _bookIdWidget {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text('Book ID'),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ...info.configIds.map(
                (e) => TChip(
                  title: Text(e),
                  onDelete: () {
                    info.configIds.remove(e);
                    setState(() {});
                  },
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: col.primaryContainer,
                  foregroundColor: col.onPrimaryContainer,
                ),
                onPressed: () async {
                  final res = await showPromptAlertDialog(context, '');
                  if (res == null) return;
                  info.configIds.add(res);
                  setState(() {});
                },
                icon: Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _urlWidget {
    return _wrapperWidget(
      'Urls',
      children: info.urls
          .map(
            (e) => TChip(
              title: Text(e),
              onDelete: () {
                info.urls.remove(e);
                setState(() {});
              },
            ),
          )
          .toList(),
      onAdd: () async {
        final res = await showPromptAlertDialog(context, '', title: 'Urls');
        if (res == null) return;
        info.urls.add(res);
        setState(() {});
      },
    );
  }

  Widget get _genresWidget {
    return _wrapperWidget(
      'Genres',
      children: info.genres
          .map(
            (e) => TChip(
              title: Text(e),
              onDelete: () {
                info.genres.remove(e);
                setState(() {});
              },
            ),
          )
          .toList(),
      onAdd: () async {
        final res = await showPromptAlertDialog(context, '', title: 'Genres');
        if (res == null) return;
        info.genres.add(res);
        setState(() {});
      },
    );
  }

  Widget get _tagsWidget {
    return _wrapperWidget(
      'Tags',
      children: info.tags
          .map(
            (e) => TChip(
              title: Text(e),
              onDelete: () {
                info.tags.remove(e);
                setState(() {});
              },
            ),
          )
          .toList(),
      onAdd: () async {
        final res = await showPromptAlertDialog(context, '', title: 'Tags');
        if (res == null) return;
        info.tags.add(res);
        setState(() {});
      },
    );
  }

  Widget _wrapperWidget(
    String title, {
    required List<Widget> children,
    void Function()? onAdd,
  }) {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(title),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ...children,
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: col.primaryContainer,
                  foregroundColor: col.onPrimaryContainer,
                ),
                onPressed: onAdd,
                icon: Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
