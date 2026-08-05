import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/main_app/components/pdf_grid_item.dart';
import 'package:than_reader/main_app/components/pdf_list_item.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/router.dart';

class PdfFavAllScreen extends StatefulWidget {
  const PdfFavAllScreen({super.key});

  @override
  State<PdfFavAllScreen> createState() => _PdfFavAllScreenState();
}

class _PdfFavAllScreenState extends State<PdfFavAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pdf Favorite"), actions: [ListStyleButton()]),
      body: StreamBuilder(
        stream: PdfFavController().stateStream,
        initialData: PdfFavController().state,
        builder: (context, snapshot) {
          final state = snapshot.data!;
          return CustomScrollView(slivers: [listStyle(state.favPathList)]);
        },
      ),
    );
  }

  Widget listStyle(List<AppFile> list) {
    return ValueListenableBuilder(
      valueListenable: ListStyleButton.valueNotifier,
      builder: (context, value, child) {
        if (value == .grid) {
          return SliverGrid.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 200,
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (context, index) => gridItem(list[index]),
          );
        }
        return SliverList.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => _listItem(list[index]),
        );
      },
    );
  }

  Widget _listItem(AppFile pdf) {
    return Card(
      child: PdfListItem(
        pdf: pdf,
        onMenuClicked: showPdfMenu,
        onClicked: goReader,
      ),
    );
  }

  Widget gridItem(AppFile pdf) {
    return PdfGridItem(
      pdf: pdf,
      onMenuClicked: showPdfMenu,
      onClicked: goReader,
    );
  }

  void goReader(AppFile pdf) async {
    await goReaderModuleApp(context, pdf);
    setState(() {});
  }

  void showPdfMenu(AppFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
