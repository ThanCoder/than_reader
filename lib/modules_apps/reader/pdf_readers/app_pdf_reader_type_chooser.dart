import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/constanst_keys.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdf_params.dart';

class AppAutoReaderTypeChooser extends StatefulWidget {
  const AppAutoReaderTypeChooser({super.key});

  @override
  State<AppAutoReaderTypeChooser> createState() =>
      _AppAutoReaderTypeChooserState();

  static final valueNotifier = ValueNotifier<PdfReaderType>(.autoReader);

  static void init() {
    valueNotifier.value = PdfReaderType.fromName(
      CFBStore.getInstance.getString(appChooseAutoReaderType),
    );
  }

  static void setValue(PdfReaderType type) {
    CFBStore.getInstance.putAndWriteAll(appChooseAutoReaderType, type.name);
    valueNotifier.value = type;
  }
}

class _AppAutoReaderTypeChooserState extends State<AppAutoReaderTypeChooser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Text('Auto Pdf Reader:'),
            Spacer(),
            ValueListenableBuilder(
              valueListenable: AppAutoReaderTypeChooser.valueNotifier,
              builder: (context, value, child) {
                return DropdownButton<PdfReaderType>(
                  borderRadius: .circular(3),
                  value: value,
                  items: PdfReaderType.values
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.label)),
                      )
                      .toList(),
                  onChanged: (value) {
                    AppAutoReaderTypeChooser.setValue(value!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
