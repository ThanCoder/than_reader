import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';

class PdfReaderTypeChooser extends StatefulWidget {
  final PdfReaderType? value;
  final void Function(PdfReaderType value)? onChanged;
  const PdfReaderTypeChooser({super.key, this.value, this.onChanged});

  @override
  State<PdfReaderTypeChooser> createState() => _PdfReaderTypeChooserState();

  static final readerTypeNotifier = ValueNotifier<PdfReaderType>(.autoReader);
}

class _PdfReaderTypeChooserState extends State<PdfReaderTypeChooser> {
  final list = PdfReaderType.values;

  @override
  void initState() {
    if (widget.value != null) {
      PdfReaderTypeChooser.readerTypeNotifier.value = widget.value!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      padding: EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(4),
      value: PdfReaderTypeChooser.readerTypeNotifier.value,
      items: list
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.name.toCaptalizeWords()),
            ),
          )
          .toList(),
      onChanged: (value) {
        PdfReaderTypeChooser.readerTypeNotifier.value = value!;
        widget.onChanged?.call(value);
      },
    );
  }
}
