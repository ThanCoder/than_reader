import 'dart:typed_data';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:than_reader/platforms/components/forms/input_text.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_desc.dart';

enum NovelEditFormRespCoverType { none, update, delete }

class NovelEditFormResp {
  final NovelDesc desc;
  final Uint8List? cover;
  final NovelEditFormRespCoverType type;

  const NovelEditFormResp({required this.desc, this.cover, required this.type});
}

class NovelEditForm extends StatefulWidget {
  const new({super.key, required this.desc, this.imgData});
  final NovelDesc desc;
  final Uint8List? imgData;

  @override
  State<NovelEditForm> createState() => _NovelEditFormState();
}

class _NovelEditFormState extends State<NovelEditForm> {
  late NovelDesc desc;
  Uint8List? imgData;
  @override
  void initState() {
    desc = widget.desc;
    imgData = widget.imgData;

    titleCon.text = desc.title;
    authorCon.text = desc.author;
    translatorCon.text = desc.translator;
    mcCon.text = desc.mc;
    descCon.text = desc.desc;
    super.initState();
  }

  @override
  void dispose() {
    titleCon.dispose();
    authorCon.dispose();
    translatorCon.dispose();
    mcCon.dispose();
    descCon.dispose();
    super.dispose();
  }

  final titleCon = TextEditingController();
  final authorCon = TextEditingController();
  final translatorCon = TextEditingController();
  final mcCon = TextEditingController();
  final descCon = TextEditingController();
  NovelEditFormRespCoverType coverType = .none;

  void chooseCoverImage() async {
    final picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    imgData = await image.readAsBytes();
    coverType = .update;
    if (!mounted) return;
    setState(() {});
  }

  void showCoverImageDelConf() async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete Cover Image?',
      confirmText: 'Delete',
      closeText: 'No',
      confirmColor: col.error,
      confirmForegroundColor: col.onError,
    );
    if (!conf) return;
    imgData = null;
    coverType = .delete;
    if (!mounted) return;
    setState(() {});
  }

  void save() async {
    final arg = NovelEditFormResp(
      desc: desc.copyWith(
        title: titleCon.text,
        author: authorCon.text,
        translator: translatorCon.text,
        desc: descCon.text,
        mc: mcCon.text,
      ),
      type: coverType,
      cover: imgData,
    );
    context.pop<NovelEditFormResp>(arg);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        save();
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Form')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: .start,
              children: [
                _coverImage(),
                InputText(
                  controller: titleCon,
                  maxLines: 1,
                  label: Text('Title'),
                ),

                InputText(
                  controller: authorCon,
                  maxLines: 1,
                  label: Text('Author'),
                ),
                InputText(
                  controller: translatorCon,
                  maxLines: 1,
                  label: Text('Translator'),
                ),
                InputText(controller: mcCon, maxLines: 1, label: Text('MC')),
                urlWidget,
                if (desc.urls.isNotEmpty) SizedBox(height: 10),

                tagWidget,
                if (desc.tags.isNotEmpty) SizedBox(height: 10),
                InputText(
                  controller: descCon,
                  maxLines: null,
                  label: Text('Description'),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'save',
          onPressed: save,
          child: Icon(Icons.save_as_outlined),
        ),
      ),
    );
  }

  Widget _coverImage() {
    return GestureDetector(
      onTap: () {
        if (imgData != null) {
          showCoverImageDelConf();
          return;
        }
        chooseCoverImage();
      },
      child: _coverImageRect(),
    );
  }

  ClipRRect _coverImageRect({double width = 120, double height = 175}) {
    Widget img = Icon(Icons.menu_book_outlined, size: 40);
    if (imgData != null) {
      img = Image.memory(imgData!);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(child: img),
      ),
    );
  }

  Widget get tagWidget {
    return Column(
      crossAxisAlignment: .start,
      spacing: 10,
      children: [
        Text('Tags', style: TextStyle(fontSize: 18, fontWeight: .w700)),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            for (var tag in desc.tags)
              wrapItem(
                tag,
                onDelete: (text) {
                  desc.tags.remove(text);
                  desc = desc.copyWith(tags: desc.tags);
                  setState(() {});
                },
              ),
            IconButton(
              onPressed: () async {
                final name = await showPromptAlertDialog(
                  context,
                  '',
                  title: 'New Tag',
                  confirmText: 'New',
                  onErrorCheck: (text) {
                    if (text.isEmpty) return 'text required!';
                    return null;
                  },
                );
                if (name == null || name.isEmpty) return;
                if (!mounted) return;
                desc = desc.copyWith(tags: [...desc.tags, name]);
                setState(() {});
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget get urlWidget {
    return Column(
      crossAxisAlignment: .start,
      spacing: 10,
      children: [
        Text('Page Urls', style: TextStyle(fontSize: 18, fontWeight: .w700)),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            for (var url in desc.urls)
              wrapItem(
                url,
                onDelete: (text) {
                  desc.urls.remove(text);
                  desc = desc.copyWith(urls: desc.urls);
                  setState(() {});
                },
              ),
            IconButton(
              onPressed: () async {
                final name = await showPromptAlertDialog(
                  context,
                  '',
                  title: 'New Url',
                  confirmText: 'New',
                  onErrorCheck: (text) {
                    if (text.isEmpty || !text.startsWith('http')) {
                      return 'Url required!';
                    }
                    return null;
                  },
                );
                if (name == null || name.isEmpty) return;
                if (!mounted) return;
                desc = desc.copyWith(urls: [...desc.urls, name]);
                setState(() {});
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  Widget wrapItem(String text, {void Function(String text)? onDelete}) {
    return Container(
      padding: .symmetric(vertical: 4, horizontal: 7),
      decoration: BoxDecoration(
        color: col.surfaceContainerHighest,
        borderRadius: .circular(14),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 9,
        children: [
          Text(text.safeSubstring(0, 30), overflow: .ellipsis, maxLines: 1),
          GestureDetector(
            onTap: () => onDelete?.call(text),
            child: Text(
              'X',
              style: TextStyle(
                fontSize: 20,
                fontWeight: .w800,
                color: col.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Original COMPLETED Portal Fantasy / Isekai Action Adventure Fantasy
