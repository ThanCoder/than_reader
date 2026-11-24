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
    this.lang,
    this.editChapter,
    required this.onSaved,
    required this.getLastChapter,
    required this.getChapter,
  });

  final ChapterLaguage? lang;
  final NovelChapter? editChapter;
  final Future<NovelChapter?> Function(ChapterLaguage lang, double chNumber)
  getChapter;
  final Future<NovelChapter?> Function(ChapterLaguage lang) getLastChapter;
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
  final _titleControllerFocus = FocusNode();
  final _chapterControllerFocus = FocusNode();

  late ChapterLaguage _language;
  List<IChapterContentReplacer> replacerList = [];
  bool get replacerEnable {
    if (replacerList.isEmpty) {
      return false;
    }
    for (var e in replacerList) {
      if (e.enable) return true;
    }
    return false;
  }

  @override
  void initState() {
    // config

    _loadReplacerCf();

    super.initState();
    init();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _chapterController.dispose();
    _contentCon.dispose();
    _contentFocus.dispose();
    _titleControllerFocus.dispose();
    _chapterControllerFocus.dispose();
    super.dispose();
  }

  final cf = AppUtil.instance.config;

  void _loadReplacerCf() {
    replacerList.clear();

    for (var map in cf.getMapList(novelChapterContentReplaceTextListKey)) {
      replacerList.add(ChapterContentReplacerText.fromJson(map));
    }
    for (var map in cf.getMapList(novelChapterContentReplaceLineListKey)) {
      replacerList.add(ChapterContentReplacerLine.fromJson(map));
    }
  }

  void _saveReplacerCf() {
    final lineMatcher = replacerList
        .where((e) => e.isLineMatcher)
        .map((e) => e.toJson())
        .toList();
    final textMatcher = replacerList
        .where((e) => e.isTexMatcher)
        .map((e) => e.toJson())
        .toList();

    cf
        .put(novelChapterContentReplaceTextListKey, textMatcher)
        .put(novelChapterContentReplaceLineListKey, lineMatcher)
        .writeAll();
  }

  void init() async {
    final editChapter = widget.editChapter;
    if (editChapter != null) {
      // edit
      _titleController.text = editChapter.title;
      _chapterController.text = editChapter.chapter.toString();
      _language = editChapter.lang;
      final con = await editChapter.getContentOrNull<String>();
      _contentCon.text = con ?? '';
    } else {
      // new
      _language = widget.lang ?? .myanmar;
      _titleController.text = 'Untitled';
      _chapterController.text = '1';
      _getLastChapter();
    }
  }

  void _getLastChapter() async {
    final lastCh = await widget.getLastChapter(_language);
    if (lastCh != null) {
      _chapterController.text = '${lastCh.chapter + 1}';
    } else {
      _chapterController.text = '1';
    }
    _fetchContentCurrentContent();
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
    if (!mounted) return;
    replacerList = res;
    _saveReplacerCf();
    setState(() {});
  }

  void _pastToContent() async {
    final res = await Clipboard.getData('text/plain');
    if (res == null || res.text == null) return;
    if (!mounted) return;
    _contentCon.text = res.text!;
    _contentFormChanged(res.text!);
  }

  double get _currentCh => double.tryParse(_chapterController.text.trim()) ?? 1;

  void prevChNumber() async {
    if (_currentCh <= 1) return;
    _titleController.text = 'Untitled';
    _contentCon.text = '';
    _chapterController.text = '${_currentCh - 1}';
    _fetchContentCurrentContent();
  }

  void nextChNumber() async {
    _titleController.text = 'Untitled';
    _contentCon.text = '';
    _chapterController.text = '${_currentCh + 1}';
    _fetchContentCurrentContent();
  }

  void _fetchContentCurrentContent() async {
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

  void _replaceContentAllMatcher() {
    String content = _contentCon.text;
    if (content.isEmpty) return;

    replacerList.sortUpLineMatcher();

    for (final replacer in replacerList) {
      if (!replacer.enable) continue;
      content = replacer.apply(content);
    }

    _contentCon.text = content.trim();
    _contentFormChanged(_contentCon.text);
  }

  void _replaceContentTextMatcher() {
    String content = _contentCon.text;
    if (content.isEmpty) return;

    for (final replacer in replacerList) {
      if (!replacer.enable) continue;
      if (!replacer.isTexMatcher) continue;

      content = replacer.apply(content);
    }

    _contentCon.text = content.trim();
    _contentFormChanged(_contentCon.text);
  }

  void _getLastContent() async {
    final ch = double.tryParse(_chapterController.text.trim());
    if (ch == null) return;
    // chapter
    final chapter = await widget.getChapter(_language, ch);
    if (!mounted) return;
    if (chapter == null) {
      showErrorDialog(context, '`$ch`: Chapter Not Found!');
      return;
    }
    // content
    final content = await chapter.getContentOrNull<String>();
    if (!mounted) return;
    if (content == null) {
      showErrorDialog(context, 'Last Content Not Found!');
      return;
    }
    _contentCon.text = content;
    setState(() {});
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
      // showSnackbar(context, msg);
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _form(),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: Icon(Icons.save_as_outlined),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        'Chapter Form',
        style: TextStyle(fontSize: 13, fontWeight: .w700),
      ),
      actions: [
        if (replacerEnable)
          FilledButton(
            onPressed: _replaceContentAllMatcher,
            child: Text('Replace All'),
          ),
        SizedBox(width: 5),
        // FilledButton.icon(
        //   onPressed: _save,
        //   label: Text('Save'),
        //   icon: const Icon(Icons.check_outlined),
        // ),
        // SizedBox(width: 5),
        IconButton(
          onPressed: _moreSetting,
          icon: Icon(Icons.settings_outlined),
        ),
        SizedBox(width: 5),
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
            focusNode: _titleControllerFocus,
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
            onTapOutside: (event) => _titleControllerFocus.unfocus(),
          ),

          const SizedBox(height: 16),

          _numberForm(),

          const SizedBox(height: 16),

          _langDropdownForm(),

          const SizedBox(height: 16),

          _contentForm(),

          const SizedBox(height: 90),

          // SizedBox(
          //   height: 52,
          //   child: FilledButton.icon(
          //     onPressed: _save,
          //     icon: const Icon(Icons.save),
          //     label: const Text('Save Chapter'),
          //   ),
          // ),
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
            focusNode: _chapterControllerFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Chapter Number',
              hintText: 'e.g. 1, 1.5, 2',
              prefixIcon: Icon(Icons.numbers),
              border: OutlineInputBorder(),
            ),
            onTapOutside: (event) => _chapterControllerFocus.unfocus(),
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
      spacing: 5,
      runSpacing: 5,
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

        if (replacerEnable)
          FilledButton(
            onPressed: _replaceContentAllMatcher,
            child: Text('Replace All Matcher'),
          ),
        if (replacerEnable)
          FilledButton(
            onPressed: _replaceContentTextMatcher,
            child: Text('Replace Only Text Matcher'),
          ),
        FilledButton(
          onPressed: _getLastContent,
          child: Text('Get Last Content'),
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
