import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_state_conroller.dart';
import 'package:than_reader/core/state/pdf_state_event.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_reader_type_chooser.dart';

class PdfMenu extends StatefulWidget {
  final PdfFile pdf;
  final BuildContext mainContext;
  const PdfMenu({super.key, required this.pdf, required this.mainContext});

  @override
  State<PdfMenu> createState() => _PdfMenuState();
}

class _PdfMenuState extends State<PdfMenu> {
  late PdfConfig config;
  @override
  void initState() {
    config = PdfConfig.fromPathSync(widget.pdf.configPath);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 200),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  widget.pdf.name,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: .bold),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('PDF Info'),
              onTap: () {
                context.pop();
                showInfoDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.drive_file_rename_outline),
              title: Text('Rename'),
              onTap: () {
                context.pop();
                showRenameDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete'),
              onTap: () {
                context.pop();
                showDeleteConfirm();
              },
            ),
            // ListTile(leading: Icon(Icons.tag), title: Text('Tag')),
            Card(
              child: ListTile(
                title: Text("Pdf Reader Type"),
                trailing: PdfReaderTypeChooser(
                  value: config.readerType,
                  onChanged: (value) {
                    config = config.copyWith(readerType: value);
                    config.savePath(widget.pdf.configPath);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirm() {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာသေချာပြီလား?',
      submitText: 'Delete Forever',
      onSubmit: () {
        PdfStateConroller.instance.dispatch(PdfDelete(widget.pdf));
      },
    );
  }

  void showRenameDialog() {
    final pdfFile = File(widget.pdf.path);
    final dir = Directory(pdfFile.parentPath);
    final existsName = <String>[];
    if (dir.existsSync()) {
      for (var file in dir.listSync()) {
        if (file.statSync().type != .file) continue;
        existsName.add(file.getName());
      }
    }
    // print(widget.pdf.configPath);
    existsName.remove(widget.pdf.name);
    showTReanmeDialog(
      context,
      text: widget.pdf.name.onlyName,
      barrierDismissible: false,
      submitText: 'Rename',
      onCheckIsError: (text) {
        if (text.isEmpty) return 'name required';
        if (existsName.contains('$text.pdf')) return 'Already Exists!';
        return null;
      },

      onSubmit: (text) {
        PdfStateConroller().renamePdf(widget.pdf, text);
      },
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
