import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/models/pdf_file.dart';

class PdfMenu extends StatefulWidget {
  final PdfFile pdf;
  final BuildContext mainContext;
  const PdfMenu({super.key, required this.pdf, required this.mainContext});

  @override
  State<PdfMenu> createState() => _PdfMenuState();
}

class _PdfMenuState extends State<PdfMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('PDF Info'),
          onTap: () {
            context.pop();
            showInfoDialog();
          },
        ),
      ],
    );
  }

  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3,
          children: [
            Text('T: ${widget.pdf.name}'),
            Text('Size: ${widget.pdf.size.fileSizeLabel()}'),
            Text('Date: ${widget.pdf.date.toDetailedAgeLabel()}'),
            Text('Path: ${widget.pdf.path}'),
          ],
        ),
      ),
    );
  }
}
