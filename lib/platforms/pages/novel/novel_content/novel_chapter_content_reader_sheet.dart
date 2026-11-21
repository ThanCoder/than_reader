import 'package:material_ui/material_ui.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/ui/components/scrollable_columm.dart';

class NovelChapterContentReaderSheetProps {
  const new({
    required this.hasContentText,
    required this.onCopyContentText,
    required this.fontSize,
    required this.onFontSizeChanged,
    required this.goChapterForm,
  });
  final bool hasContentText;
  final VoidCallback onCopyContentText;
  final double fontSize;
  final void Function(double fontSize) onFontSizeChanged;
  final VoidCallback goChapterForm;
}

class NovelChapterContentReaderSheet extends StatefulWidget {
  const new({super.key, required this.props});
  final NovelChapterContentReaderSheetProps props;

  @override
  State<NovelChapterContentReaderSheet> createState() =>
      _NovelChapterContentReaderSheetState();

  static Future<void> show(
    BuildContext context,
    NovelChapterContentReaderSheetProps props,
  ) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => NovelChapterContentReaderSheet(props: props),
    );
  }
}

class _NovelChapterContentReaderSheetState
    extends State<NovelChapterContentReaderSheet> {
  @override
  void initState() {
    fontSize = widget.props.fontSize;
    super.initState();
  }

  late double fontSize;
  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      spacing: 10,
      children: [
        if (widget.props.hasContentText)
          ListTile(
            tileColor: context.colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(borderRadius: .circular(14)),
            leading: Icon(Icons.copy_all_outlined),
            title: Text('Copy Content'),
            onTap: () {
              context.pop();
              widget.props.onCopyContentText();
            },
          ),
        _fontForm(),

        ListTile(
          tileColor: context.colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          leading: Icon(Icons.edit_document),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          title: Text('Edit Chapter Form'),
          onTap: () {
            context.pop();
            widget.props.goChapterForm();
          },
        ),
        SizedBox(height: 80),
      ],
    );
  }

  Widget _fontForm() {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 9),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: .circular(14),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: .start,
        children: [
          Text(
            'Font Size: ${fontSize.toInt()}',
            style: TextStyle(fontSize: 18, fontWeight: .w700),
          ),
          Slider.adaptive(
            min: 10,
            max: 25,
            value: fontSize.clamp(10, 25),
            onChanged: (value) {
              fontSize = value;
              setState(() {});
              widget.props.onFontSizeChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
