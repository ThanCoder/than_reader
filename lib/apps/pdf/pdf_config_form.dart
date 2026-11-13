import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:than_reader/core/reader_config/pdf_config.dart';
import 'package:than_reader/ui/index.dart';

class PdfConfigForm extends StatefulWidget {
  const new({super.key, required this.config, required this.onSaved});
  final PdfConfig config;
  final void Function(PdfConfig newConfig) onSaved;

  @override
  State<PdfConfigForm> createState() => _PdfConfigFormState();
}

class _PdfConfigFormState extends State<PdfConfigForm> {
  late PdfConfig config;

  final pageCon = TextEditingController();

  @override
  void initState() {
    config = widget.config;
    pageCon.text = config.page.toString();
    super.initState();
  }

  @override
  void dispose() {
    pageCon.dispose();
    super.dispose();
  }

  void save() async {
    widget.onSaved(config.copyWith(page: int.parse(pageCon.text)));
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
            inputTextProps: .new(
              maxLines: 1,
              label: Text('Page Number'),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: .number,
            ),
          ),
          SwitchListTile.adaptive(
            shape: RoundedRectangleBorder(borderRadius: .circular(14)),
            tileColor: context.colorScheme.surfaceContainer,
            title: Text('Adult Novel'),
            value: config.isAdult,
            onChanged: (value) {
              config = config.copyWith(isAdult: value);
              setState(() {});
            },
          ),
          SwitchListTile.adaptive(
            shape: RoundedRectangleBorder(borderRadius: .circular(14)),
            tileColor: context.colorScheme.surfaceContainer,
            title: Text('Completed Novel'),
            value: config.isCompleted,
            onChanged: (value) {
              config = config.copyWith(isCompleted: value);
              setState(() {});
            },
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
