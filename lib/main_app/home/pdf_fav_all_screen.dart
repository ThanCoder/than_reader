import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/main_app/components/pdf_grid_item.dart';
import 'package:than_reader/main_app/components/pdf_list_item.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_app.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/partials/list_style_button.dart';

class PdfFavAllScreen extends StatefulWidget {
  const PdfFavAllScreen({super.key});

  @override
  State<PdfFavAllScreen> createState() => _PdfFavAllScreenState();
}

class _PdfFavAllScreenState extends State<PdfFavAllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pdf Favorite")),
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

  Widget listStyle(List<PdfFile> list) {
    return ValueListenableBuilder(
      valueListenable: ListStyleButton.listStyleButtonTypeNotifier,
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

  Widget _listItem(PdfFile pdf) {
    return Card(
      child: PdfListItem(
        pdf: pdf,
        onMenuClicked: showPdfMenu,
        onClicked: goReader,
      ),
    );
  }

  Widget gridItem(PdfFile pdf) {
    return PdfGridItem(
      pdf: pdf,
      onMenuClicked: showPdfMenu,
      onClicked: goReader,
    );
  }

  void goReader(PdfFile pdf) async {
    await AppManager.instance.go<PdfApp, PdfParams, PdfResult>(
      context,
      PdfParams(path: pdf.path),
    );
    setState(() {});
  }

  void showPdfMenu(PdfFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
