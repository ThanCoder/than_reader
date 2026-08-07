import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/pdf_grid_item.dart';
import 'package:than_reader/main_app/components/pdf_list_item.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/router.dart';

enum AppResultScreenShowType { none, folderResult }

class AppResultScreen extends StatefulWidget {
  final String title;
  final List<ReaderFile> list;
  final AppResultScreenShowType type;
  const AppResultScreen({
    super.key,
    required this.title,
    required this.list,
    this.type = .none,
  });

  @override
  State<AppResultScreen> createState() => _AppResultScreenState();
}

class _AppResultScreenState extends State<AppResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 14),
          maxLines: 1,
          overflow: .ellipsis,
        ),
        actions: [ListStyleButton()],
      ),
      body: CustomScrollView(slivers: [listStyle]),
    );
  }

  Widget get listStyle {
    return ValueListenableBuilder(
      valueListenable: ListStyleButton.valueNotifier,
      builder: (context, value, child) {
        if (value == .grid) {
          return SliverGrid.builder(
            itemCount: widget.list.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 200,
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (context, index) => gridItem(widget.list[index]),
          );
        }
        return SliverList.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) => _listItem(widget.list[index]),
        );
      },
    );
  }

  Widget _listItem(ReaderFile pdf) {
    return Card(
      child: PdfListItem(
        pdf: pdf,
        onMenuClicked: showPdfMenu,
        onClicked: goReader,
      ),
    );
  }

  Widget gridItem(ReaderFile pdf) {
    return PdfGridItem(
      pdf: pdf,
      onMenuClicked: showPdfMenu,
      onClicked: goReader,
    );
  }

  void goReader(ReaderFile pdf) async {
    await goReaderModuleApp(context, pdf);

    setState(() {});
  }

  void showPdfMenu(ReaderFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
