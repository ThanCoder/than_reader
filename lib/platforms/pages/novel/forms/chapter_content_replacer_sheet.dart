import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/models/chapter_content_replacer.dart';
import 'package:than_reader/ui/components/scrollable_columm.dart';
import 'package:than_reader/ui/index.dart';

class ChapterContentReplacerSheet extends StatefulWidget {
  const new({super.key, required this.list});
  final List<IChapterContentReplacer> list;

  @override
  State<ChapterContentReplacerSheet> createState() =>
      _ChapterContentReplacerSheetState();

  static Future<List<IChapterContentReplacer>?> show(
    BuildContext context,
    List<IChapterContentReplacer> list,
  ) {
    return showModalBottomSheet<List<IChapterContentReplacer>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ChapterContentReplacerSheet(list: list),
    );
  }
}

class _ChapterContentReplacerSheetState
    extends State<ChapterContentReplacerSheet> {
  final _matchTextCon = TextEditingController();
  final _matchLineStartCon = TextEditingController();
  final _matchLinesCon = TextEditingController();
  final _toTextCon = TextEditingController();
  late List<IChapterContentReplacer> _list;

  @override
  void initState() {
    _list = widget.list;
    super.initState();
  }

  IChapterContentReplacer? _item;
  bool isNumber = false;

  void _newLineItem() {
    final item = ChapterContentReplacerLine(
      id: 'ch-content-line-${DateTime.now().millisecondsSinceEpoch}',
      line: 0,
      toText: '',
      start: 0,
      enable: true,
    );
    _list.add(item);
    _item = item;
    _matchLineStartCon.text = item.start.toString();
    _matchLinesCon.text = item.line.toString();
    _toTextCon.text = item.toText;
    isNumber = true;
    setState(() {});
  }

  void _newTextItem() {
    final item = ChapterContentReplacerText(
      id: 'ch-content-text-${DateTime.now().millisecondsSinceEpoch}',
      matchText: '',
      toText: '',
      enable: true,
    );
    _list.add(item);
    _item = item;
    _matchTextCon.text = item.matchText;
    _toTextCon.text = item.toText;
    isNumber = false;
    setState(() {});
  }

  void _update() {
    final item = _item;
    if (item == null) return;
    final index = _list.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    if (item is ChapterContentReplacerLine) {
      _list[index] = item.copyWith(
        start: int.parse(_matchLineStartCon.text),
        line: int.parse(_matchLinesCon.text),
        toText: _toTextCon.text,
      );
    }
    if (item is ChapterContentReplacerText) {
      _list[index] = item.copyWith(
        matchText: _matchTextCon.text,
        toText: _toTextCon.text,
      );
    }
    _item = null;
    setState(() {});
  }

  void onEdit(IChapterContentReplacer item) {
    _item = item;
    if (item is ChapterContentReplacerLine) {
      isNumber = true;
      _matchLineStartCon.text = item.start.toString();
      _matchLinesCon.text = item.line.toString();
      _toTextCon.text = item.toText;
    }
    if (item is ChapterContentReplacerText) {
      _matchTextCon.text = item.matchText;
      _toTextCon.text = item.toText;
    }
    setState(() {});
  }

  void onDelete(IChapterContentReplacer item) {
    final index = _list.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    _item = null;
    _list.removeAt(index);
    setState(() {});
  }

  void _onEnableChanged(bool enable, IChapterContentReplacer item) {
    final index = _list.indexWhere((it) => it.id == item.id);
    if (index == -1) return;
    if (item is ChapterContentReplacerLine) {
      _list[index] = item.copyWith(enable: enable);
    }
    if (item is ChapterContentReplacerText) {
      _list[index] = item.copyWith(enable: enable);
    }
    setState(() {});
  }

  void _save() {
    context.pop(_list);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _save();
      },
      child: Padding(
        padding: .only(bottom: context.viewInsets.bottom),
        child: ScrollableColumn(
          children: [
            if (_item != null) _form,
            if (_item == null) _newActions(),
            _listWidget,
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: .end,
              children: [FilledButton(onPressed: _save, child: Text('Save'))],
            ),
          ],
        ),
      ),
    );
  }

  Widget _newActions() {
    return Row(
      spacing: 10,
      children: [
        FilledButton(onPressed: _newTextItem, child: Text('New Text Item')),
        FilledButton(onPressed: _newLineItem, child: Text('New Lines Item')),
      ],
    );
  }

  Widget get _form {
    return Form(
      child: Column(
        spacing: 12,
        children: [
          Text('Edit Form'),
          if (isNumber)
            FormInputText(
              controller: _matchLineStartCon,
              inputTextProps: .new(
                maxLines: 1,
                keyboardType: .number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                label: Text(
                  'Start Line ([0] start position,[-1] end position)',
                ),
              ),
            )
          else
            FormInputText(
              controller: _matchTextCon,
              inputTextProps: .new(
                maxLines: null,
                label: Text('Match Text (Search Text)'),
              ),
            ),
          if (isNumber)
            FormInputText(
              controller: _matchLinesCon,
              inputTextProps: .new(
                maxLines: 1,
                keyboardType: .number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                label: Text('Replace Lines Number ([0] range)'),
              ),
            ),
          FormInputText(
            controller: _toTextCon,
            inputTextProps: .new(
              maxLines: null,
              label: Text('To Text (Replace Text)'),
            ),
          ),
          Row(
            mainAxisAlignment: .end,
            children: [FilledButton(onPressed: _update, child: Text('Update'))],
          ),
        ],
      ),
    );
  }

  Widget get _listWidget {
    return Column(children: widget.list.map((e) => _listItem(e)).toList());
  }

  GestureDetector _listItem(IChapterContentReplacer e) {
    return GestureDetector(
      onTap: () => onEdit(e),
      child: Container(
        margin: .only(bottom: 10),
        padding: .symmetric(vertical: 5, horizontal: 7),
        decoration: BoxDecoration(
          color: e == _item
              ? context.colorScheme.surfaceContainerHigh
              : context.colorScheme.surfaceContainer,
          borderRadius: .circular(12),
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                crossAxisAlignment: .center,
                children: [
                  Checkbox.adaptive(
                    value: e.enable,
                    onChanged: (value) => _onEnableChanged(value!, e),
                  ),
                  Expanded(child: _itemMatcher(e)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => onEdit(e),
              icon: Icon(Icons.edit_document),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () => onDelete(e),
              icon: Icon(Icons.delete_forever_outlined),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _itemMatcher(IChapterContentReplacer e) {
    return switch (e) {
      ChapterContentReplacerLine line => Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        spacing: 5,
        children: [
          Text(
            'start: ${line.start}',
            maxLines: 1,
            style: TextStyle(fontSize: 11, fontWeight: .w600),
          ),
          Text(
            'Lines: ${line.line}',
            maxLines: 1,
            style: TextStyle(fontSize: 11, fontWeight: .w600),
          ),
          if (line.toText.isNotEmpty)
            Text(
              line.toText,
              maxLines: 2,
              style: TextStyle(fontSize: 10, fontWeight: .w400),
            ),
        ],
      ),
      ChapterContentReplacerText text => Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .center,
        spacing: 5,
        children: [
          Text(
            text.matchText,
            maxLines: 1,
            style: TextStyle(fontSize: 11, fontWeight: .w600),
          ),
          if (text.toText.isNotEmpty)
            Text(
              text.toText,
              maxLines: 2,
              style: TextStyle(fontSize: 10, fontWeight: .w400),
            ),
        ],
      ),
    };
  }
}
