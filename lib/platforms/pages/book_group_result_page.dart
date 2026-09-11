import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/list_style/list_style_provider.dart';
import 'package:than_reader/platforms/components/menu/item_menu.dart';
import 'package:than_reader/platforms/components/reader_grid_item.dart';
import 'package:than_reader/platforms/components/reader_list_item.dart';
import 'package:than_reader/router.dart';

class BookGroupResultPage extends StatefulWidget {
  const new({super.key, required this.title, required this.files});
  final String title;
  final List<ReaderFile> files;

  @override
  State<BookGroupResultPage> createState() => _BookGroupResultPageState();
}

class _BookGroupResultPageState extends State<BookGroupResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _body,
    );
  }

  Widget get _body {
    return ListStyleProvider(
      gridBuilder: (context) => GridView.builder(
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
      ),
      listBuilder: (context) => ListView.separated(
        itemCount: widget.files.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) => ReaderListItem(
          file: widget.files[index],
          onClicked: onClicked,
          onRightClicked: onRightClicked,
        ),
      ),
    );
  }

  void onClicked(ReaderFile file) async {
    await goReaderModuleApp(context, file);
    if (!mounted) return;
    setState(() {});
  }

  void onRightClicked(ReaderFile file) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ItemMenu(file: file),
    );
  }
}
