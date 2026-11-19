import 'package:material_ui/material_ui.dart';
import 'package:than_reader/ui/components/scrollable_columm.dart';
import 'package:than_reader/ui/index.dart';

class ChapterFormSettingProps {
  final VoidCallback showReplacerSetting;

  new({required this.showReplacerSetting});
}

class ChapterFormSettingSheet extends StatefulWidget {
  const new({super.key, required this.props});
  final ChapterFormSettingProps props;

  @override
  State<ChapterFormSettingSheet> createState() =>
      _ChapterFormSettingSheetState();

  static Future<void> show(
    BuildContext context,
    ChapterFormSettingProps props,
  ) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ChapterFormSettingSheet(props: props),
    );
  }
}

class _ChapterFormSettingSheetState extends State<ChapterFormSettingSheet> {
  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      crossAxisAlignment: .start,
      children: [
        Text('Form Setting', style: TextStyle(fontSize: 18, fontWeight: .w700)),
        SizedBox(height: 10),
        ListTile(
          tileColor: context.colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: .circular(14)),
          title: Text('Replace Text'),
          onTap: () {
            context.pop();
            widget.props.showReplacerSetting();
          },
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
