import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:t_widgets/t_widgets.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key, required this.pickerColor});

  final Color pickerColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  @override
  void initState() {
    pickerColor = widget.pickerColor;

    super.initState();
  }

  late Color pickerColor;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      content: ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: (value) {
          pickerColor = value;
        },
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: col.surfaceContainerHighest,
            foregroundColor: col.onSurface,
          ),
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: col.primary,
            foregroundColor: col.onPrimary,
          ),
          onPressed: () {
            context.pop<Color>(pickerColor);
          },
          child: Text('Got It'),
        ),
      ],
    );
  }
}
