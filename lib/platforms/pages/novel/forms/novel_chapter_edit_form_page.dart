import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';

class NovelChapterEditFormPageRes {
  final NovelChapter chapter;
  final String contentText;

  const NovelChapterEditFormPageRes({
    required this.chapter,
    required this.contentText,
  });
}

class NovelChapterEditFormPage extends StatefulWidget {
  const new({super.key, required this.chapter, required this.box});

  final NovelChapter chapter;
  final DuBox<NovelChapter> box;

  @override
  State<NovelChapterEditFormPage> createState() =>
      _NovelChapterEditFormPageState();
}

class _NovelChapterEditFormPageState extends State<NovelChapterEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _chapterController = TextEditingController();
  final contentCon = TextEditingController();

  late ChapterLaguage _language;

  @override
  void initState() {
    _titleController.text = widget.chapter.title;
    _chapterController.text = widget.chapter.chapter.toString();
    _language = widget.chapter.lang;
    super.initState();
    init();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _chapterController.dispose();
    contentCon.dispose();
    super.dispose();
  }

  void init() async {
    final res = await widget.chapter.getContentOrNull<String>();
    contentCon.text = res ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.pop(
      NovelChapterEditFormPageRes(
        chapter: widget.chapter.copyWith(
          title: _titleController.text.trim(),
          lang: _language,
          chapter: double.parse(_chapterController.text.trim()),
          date: .now(),
        ),
        contentText: contentCon.text,
      ),
    );
  }

  String _languageName(ChapterLaguage language) {
    return switch (language) {
      ChapterLaguage.myanmar => 'Myanmar',
      ChapterLaguage.english => 'English',
      ChapterLaguage.china => 'Chinese',
    };
  }

  IconData _languageIcon(ChapterLaguage language) {
    return switch (language) {
      ChapterLaguage.myanmar => Icons.translate,
      ChapterLaguage.english => Icons.language,
      ChapterLaguage.china => Icons.translate,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Chapter'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: 'Save',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Chapter Title',
                hintText: 'Enter chapter title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Chapter title is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _chapterController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Chapter Number',
                hintText: 'e.g. 1, 1.5, 2',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Chapter number is required';
                }

                final chapter = double.tryParse(value.trim());

                if (chapter == null) {
                  return 'Enter a valid chapter number';
                }

                if (chapter < 0) {
                  return 'Chapter number cannot be negative';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<ChapterLaguage>(
              initialValue: _language,
              decoration: const InputDecoration(
                labelText: 'Language',
                prefixIcon: Icon(Icons.language),
                border: OutlineInputBorder(),
              ),
              items: ChapterLaguage.values.map((language) {
                return DropdownMenuItem(
                  value: language,
                  child: Row(
                    children: [
                      Icon(_languageIcon(language), size: 20),
                      const SizedBox(width: 12),
                      Text(_languageName(language)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _language = value;
                });
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: contentCon,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Chapter Content',
                hintText: 'Enter chapter Content',
                // prefixIcon: Icon(Icons.content_cut_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Chapter content is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Update Chapter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
