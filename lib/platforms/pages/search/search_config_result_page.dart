import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/menu/reader_item_menu_sheet.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/router.dart';

class SearchConfigResultPage extends StatefulWidget {
  const new({super.key, required this.title, required this.files});
  final String title;
  final List<ReaderFile> files;

  @override
  State<SearchConfigResultPage> createState() => _SearchConfigResultPageState();
}

class _SearchConfigResultPageState extends State<SearchConfigResultPage> {
  void onClicked(ReaderFile file) async {
    await goReaderModuleApp(context, file);
    if (!mounted) return;
    setState(() {});
  }

  void onRightClicked(ReaderFile file) async {
    ReaderItemMenuSheet.show(context, file: file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: CustomScrollView(slivers: [_resultWidget()]),
    );
  }

  SliverGrid _resultWidget() {
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: .68,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: widget.files.length,
      itemBuilder: (context, index) => ReaderGridItem(
        file: widget.files[index],
        onClicked: onClicked,
        onRightClicked: onRightClicked,
      ),
    );
  }
}
