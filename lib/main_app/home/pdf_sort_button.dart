import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/state/pdf_state_conroller.dart';

class PdfSortButton extends StatefulWidget {
  const PdfSortButton({super.key});

  @override
  State<PdfSortButton> createState() => _PdfSortButtonState();
}

class _PdfSortButtonState extends State<PdfSortButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: showSortDialog, icon: Icon(Icons.sort));
  }

  void showSortDialog() {
    showTSortDialog(
      context,
      currentId: PdfStateConroller.instance.state.sortId,
      isAsc: PdfStateConroller.instance.state.isAsc,
      sortList: PdfStateConroller.instance.sortList,
      sortDialogCallback: (id, isAsc) {
        PdfStateConroller.instance.setSort(id, isAsc);
      },
    );
  }
}
