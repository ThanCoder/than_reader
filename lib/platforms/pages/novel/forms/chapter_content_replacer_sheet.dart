import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/models/chapter_content_replacer.dart';
import 'package:than_reader/ui/components/scrollable_columm.dart';
import 'package:than_reader/ui/index.dart';

class ChapterContentReplacerSheet extends StatefulWidget {
  const new({super.key, required this.list});
  final List<ChapterContentReplacer> list;

  @override
  State<ChapterContentReplacerSheet> createState() =>
      _ChapterContentReplacerSheetState();

  static Future<List<ChapterContentReplacer>?> show(
    BuildContext context,
    List<ChapterContentReplacer> list,
  ) {
    return showModalBottomSheet<List<ChapterContentReplacer>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ChapterContentReplacerSheet(list: list),
    );
  }
}

class _ChapterContentReplacerSheetState
    extends State<ChapterContentReplacerSheet> {
  final _matchCon = TextEditingController();
  final _toTextCon = TextEditingController();
  late List<ChapterContentReplacer> _list;

  @override
  void initState() {
    _list = widget.list;
    super.initState();
  }

  ChapterContentReplacer? _item;
  void _newItem() {
    final item = ChapterContentReplacer(
      id: 'ch-content-${DateTime.now().millisecondsSinceEpoch}',
      matchText: '',
      toText: '',
    );
    _list.add(item);
    _item = item;
    _matchCon.text = item.matchText;
    _toTextCon.text = item.toText;
    setState(() {});
  }

  void _update() {
    final index = _list.indexWhere((e) => e.id == _item!.id);
    if (index == -1) return;
    _list[index] = _item!.copyWith(
      matchText: _matchCon.text,
      toText: _toTextCon.text,
    );
    _item = null;
    setState(() {});
  }

  void _save() {
    context.pop(_list);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      children: [
        if (_item != null) _form,
        if (_item == null)
          FilledButton(onPressed: _newItem, child: Text('New Item')),
        _listWidget,
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: .end,
          children: [FilledButton(onPressed: _save, child: Text('Save'))],
        ),
      ],
    );
  }

  Widget get _form {
    return Form(
      child: Column(
        spacing: 12,
        children: [
          Text('Edit Form'),
          FormInputText(
            controller: _matchCon,
            inputTextProps: .new(
              maxLines: 1,
              label: Text('Match Text (Search Text)'),
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
    return Column(
      children: widget.list
          .map(
            (e) => Container(
              margin: .only(bottom: 10),
              padding: .symmetric(vertical: 5, horizontal: 7),
              decoration: BoxDecoration(
                color: e == _item
                    ? context.colorScheme.surfaceContainerHigh
                    : context.colorScheme.surfaceContainer,
                borderRadius: .circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 5,
                    children: [
                      Text(
                        e.matchText,
                        maxLines: 1,
                        style: TextStyle(fontSize: 11, fontWeight: .w600),
                      ),
                      Text(
                        e.toText,
                        maxLines: 2,
                        style: TextStyle(fontSize: 10, fontWeight: .w400),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      _item = e;
                      setState(() {});
                    },
                    icon: Icon(Icons.edit_document),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      _item = null;
                      final index = _list.indexWhere((it) => it.id == e.id);
                      if (index == -1) return;
                      _list.removeAt(index);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete_forever_outlined),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
