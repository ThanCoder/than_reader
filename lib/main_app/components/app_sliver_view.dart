import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/main_app/components/pdf_grid_item.dart';
import 'package:than_reader/main_app/components/pdf_list_item.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/main_app/home/home_page/reader_file_list_page.dart';
import 'package:than_reader/router.dart';

class AppSliverView extends StatefulWidget {
  final List<ReaderFile> list;
  const AppSliverView({super.key, required this.list});

  @override
  State<AppSliverView> createState() => _AppSliverViewState();
}

class _AppSliverViewState extends State<AppSliverView> {
  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (context, index) =>
              Card(child: _listItem(widget.list[index])),
        );
      },
    );
  }

  Widget _listItem(ReaderFile pdf) {
    return PdfListItem(
      pdf: pdf,
      onMenuClicked: showPdfMenu,
      onClicked: goReader,
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
    ReaderFileListPage.desktopEnable.value = false;
    await goReaderModuleApp(context, pdf);
    ReaderFileListPage.desktopEnable.value = true;
  }

  void showPdfMenu(ReaderFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
