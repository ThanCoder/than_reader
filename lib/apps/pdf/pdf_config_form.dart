import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/platforms/components/forms/input_text.dart';

class PdfConfigForm extends StatefulWidget {
  const new({super.key, required this.config, required this.onSaved});
  final PdfConfig config;
  final void Function(PdfConfig newConfig) onSaved;

  @override
  State<PdfConfigForm> createState() => _PdfConfigFormState();
}

class _PdfConfigFormState extends State<PdfConfigForm> {
  final pageCon = TextEditingController();

  @override
  void initState() {
    pageCon.text = widget.config.page.toString();
    super.initState();
  }

  @override
  void dispose() {
    pageCon.dispose();
    super.dispose();
  }

  void save() async {
    widget.onSaved(widget.config.copyWith(page: int.parse(pageCon.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 12,
        children: [
          InputText(
            controller: pageCon,
            maxLines: 1,
            label: Text('Page'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: .number,
          ),

          Row(
            mainAxisAlignment: .end,
            children: [FilledButton(onPressed: save, child: Text('Save'))],
          ),
        ],
      ),
    );
  }
}
