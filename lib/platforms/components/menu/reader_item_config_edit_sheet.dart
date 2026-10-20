import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_config_form.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/reader_file_util.dart';

class ReaderItemConfigEditSheet extends StatefulWidget {
  const new({super.key, required this.file});
  final ReaderFile file;

  @override
  State<ReaderItemConfigEditSheet> createState() =>
      _ReaderItemConfigEditSheetState();

  static Future<void> show(
    BuildContext context, {
    required ReaderFile file,
  }) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ReaderItemConfigEditSheet(file: file),
    );
  }
}

class _ReaderItemConfigEditSheetState extends State<ReaderItemConfigEditSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          spacing: 20,
          children: [
            Text('Edit ${widget.file.type.label}'),
            Divider(),
            formWidget,

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget get formWidget {
    if (widget.file.type == .pdf) {
      return FutureBuilder(
        future: ReaderFileUtil.getPdfConfig(widget.file),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final res = snapshot.data!;
            if (res.isOk) {
              return PdfConfigForm(
                config: res.unwrap(),
                onSaved: (newConfig) {
                  context.pop();
                  ReaderFileUtil.savePdfConfig(newConfig, widget.file);
                },
              );
            }
          }

          return SizedBox.shrink();
        },
      );
    }
    return Text('Not Implement!');
  }
}
