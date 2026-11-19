import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/novel/forms/chapter_content_replacer_sheet.dart';
import 'package:than_reader/platforms/pages/novel/forms/chapter_form_setting_sheet.dart';
import 'package:than_reader/platforms/pages/novel/models/chapter_content_replacer.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_chapter.dart';
import 'package:than_reader/ui/index.dart';

class NovelChapterFormPage extends StatefulWidget {
  const new({
    super.key,
    this.lang = .myanmar,
    this.editChapter,
    required this.onSaved,
    required this.getLastChapter,
    required this.getChapter,
  });

  final ChapterLaguage lang;
  final NovelChapter? editChapter;
  final Future<NovelChapter?> Function(ChapterLaguage lang, double chNumber)
  getChapter;
  final NovelChapter? Function(ChapterLaguage lang) getLastChapter;
  final Future<String?> Function(NovelChapter savedChapter, String contentText)
  onSaved;

  @override
  State<NovelChapterFormPage> createState() => _NovelChapterFormPageState();
}

class _NovelChapterFormPageState extends State<NovelChapterFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _chapterController = TextEditingController();
  final _contentCon = TextEditingController();
  final _contentFocus = FocusNode();

  late ChapterLaguage _language;
  List<ChapterContentReplacer> replacerList = [];

  @override
  void initState() {
    final editChapter = widget.editChapter;
    if (editChapter != null) {
      _titleController.text = editChapter.title;
      _chapterController.text = editChapter.chapter.toString();
      _language = editChapter.lang;
    } else {
      // new
      _language = widget.lang;
      _titleController.text = 'Untitled';
      _chapterController.text = '1';
      _getLastChapter();
    }
    // config
    replacerList = cf
        .getMapList(novelChapterContentReplaceListKey)
        .map((e) => ChapterContentReplacer.fromJson(e))
        .toList();

    super.initState();
    init();
  }

  final cf = AppUtil.instance.config;

  @override
  void dispose() {
    _titleController.dispose();
    _chapterController.dispose();
    _contentCon.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void init() async {
    // final res = await widget.chapter.getContentOrNull<String>();
    final res = await widget.getChapter(
      _language,
      double.tryParse(_chapterController.text) ?? 0,
    );
    if (res != null) {
      final content = await res.getContentOrNull<String>();
      _contentCon.text = content ?? '';
    }
  }

  void _getLastChapter() async {
    final lastCh = widget.getLastChapter(_language);
    if (lastCh != null) {
      _chapterController.text = '${lastCh.chapter + 1}';
    } else {
      _chapterController.text = '1';
    }
  }

  void _moreSetting() async {
    await ChapterFormSettingSheet.show(
      context,
      .new(showReplacerSetting: showReplacerSetting),
    );
  }

  void showReplacerSetting() async {
    final res = await ChapterContentReplacerSheet.show(context, replacerList);
    if (res == null) return;
    replacerList = res;
    cf.putAndWriteAll(
      novelChapterContentReplaceListKey,
      res.map((e) => e.toJson()).toList(),
    );
  }

  void _pastToContent() async {
    final res = await Clipboard.getData('text/plain');
    if (res == null || res.text == null) return;
    if (!mounted) return;
    _contentCon.text = res.text!;
    setState(() {});
  }

  double get _currentCh => double.tryParse(_chapterController.text.trim()) ?? 1;

  void prevChNumber() async {
    if (_currentCh <= 1) return;
    _titleController.text = 'Untitled';
    _contentCon.text = '';
    _chapterController.text = '${_currentCh - 1}';
    final ch = await widget.getChapter(_language, _currentCh);
    if (ch == null) return;
    _titleController.text = ch.title;
    final res = await ch.getContentOrNull<String>();
    _contentCon.text = res ?? '';
  }

  void nextChNumber() async {
    _titleController.text = 'Untitled';
    _contentCon.text = '';
    _chapterController.text = '${_currentCh + 1}';
    final ch = await widget.getChapter(_language, _currentCh);
    if (ch == null) return;
    _titleController.text = ch.title;
    final res = await ch.getContentOrNull<String>();
    _contentCon.text = res ?? '';
  }

  void _contentFormChanged(String val) {
    if (val.isEmpty) return;
    final lines = val.split('\n');
    if (lines.isEmpty) return;
    _titleController.text = lines.first.trim();
  }

  void _replaceContentText() {
    String content = _contentCon.text;
    if (content.isEmpty) return;

    for (final replacer in replacerList) {
      content = replacer.apply(content);
    }

    _contentCon.text = content.trim();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final ch = double.parse(_chapterController.text.trim());

      final msg = await widget.onSaved(
        .new(
          title: _titleController.text,
          lang: _language,
          chapter: ch,
          date: .now(),
        ),
        _contentCon.text.trim(),
      );
      if (msg == null) return;
      _titleController.text = 'Untitled';
      nextChNumber();

      if (!mounted) return;
      showSuccessDialog(context, msg);
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appbar(), body: _form());
  }

  AppBar _appbar() {
    return AppBar(
      title: Text('Chapter Form'),
      actions: [
        FilledButton.icon(
          onPressed: _save,
          label: Text('Save'),
          icon: const Icon(Icons.check_outlined),
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: _moreSetting,
          icon: Icon(Icons.settings_outlined),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Form _form() {
    return Form(
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

          _numberForm(),

          const SizedBox(height: 16),

          _langDropdownForm(),

          const SizedBox(height: 16),

          _contentForm(),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Chapter'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberForm() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _chapterController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        ),
        SizedBox(width: 10),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.surfaceContainer,
          ),
          icon: Icon(Icons.exposure_neg_1, color: Colors.red),
          onPressed: prevChNumber,
        ),
        SizedBox(width: 10),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.surfaceContainer,
          ),
          icon: Icon(Icons.plus_one_outlined, color: Colors.green),
          onPressed: nextChNumber,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  DropdownButtonFormField<ChapterLaguage> _langDropdownForm() {
    return DropdownButtonFormField<ChapterLaguage>(
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
              Icon(language.icon, size: 20),
              const SizedBox(width: 12),
              Text(language.label),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        _language = value;
        setState(() {});
        _getLastChapter();
      },
    );
  }

  Widget _contentForm() {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        _contentFormActions(),
        TextFormField(
          focusNode: _contentFocus,
          controller: _contentCon,
          decoration: const InputDecoration(
            labelText: 'Chapter Content',
            hintText: 'Enter chapter Content',
            // prefixIcon: Icon(Icons.content_cut_outlined),
            border: OutlineInputBorder(),
          ),
          maxLines: null,
          onTapOutside: (event) {
            _contentFocus.unfocus();
          },
          onChanged: _contentFormChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Chapter content is required';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _contentFormActions() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.surfaceContainer,
          ),
          icon: Icon(Icons.paste_outlined),
          onPressed: _pastToContent,
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.surfaceContainer,
          ),
          icon: Icon(Icons.copy_all_outlined),
          onPressed: () {
            Clipboard.setData(.new(text: _contentCon.text));
          },
        ),
        FilledButton(
          onPressed: () async {
            final ch = double.tryParse(_chapterController.text.trim());
            if (ch == null) return;
            // chapter
            final chapter = await widget.getChapter(_language, ch);
            if (!mounted) return;
            if (chapter == null) {
              showErrorDialog(context, '`$ch`: Chapter No Found!');
              return;
            }
            // content
            final content = await chapter.getContentOrNull<String>();
            if (!mounted) return;
            if (content == null) {
              showErrorDialog(context, 'Last Content Text No Found!');
              return;
            }
            _contentCon.text = content;
            setState(() {});
          },
          child: Text('Get Last Content'),
        ),
        FilledButton(
          onPressed: _replaceContentText,
          child: Text('Replace Text'),
        ),
        FilledButton(
          onPressed: () {
            _contentCon.text = '';
          },
          child: Text('Clear Text'),
        ),
      ],
    );
  }
}
