import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_widgets/t_widgets.dart';

class PdfJumpPageDialog extends StatefulWidget {
  const PdfJumpPageDialog({
    super.key,
    required this.current,
    required this.maxPage,
  });
  final int current;
  final int maxPage;

  @override
  State<PdfJumpPageDialog> createState() => _PdfJumpPageDialogState();
}

class _PdfJumpPageDialogState extends State<PdfJumpPageDialog> {
  @override
  void initState() {
    controller.text = widget.current.toString();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final controller = TextEditingController();
  String? errorText;
  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return AlertDialog.adaptive(
      scrollable: true,
      title: Text('Jump Page'),
      content: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: .circular(12)),
              errorText: errorText,
            ),
            controller: controller,
            maxLines: 1,
            maxLength: widget.maxPage.toString().length,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: .number,
            onSubmitted: (value) {
              if (errorText != null) return;
              context.pop<int>(int.parse(controller.text));
            },
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  errorText = 'Number Required!';
                });
                return;
              }
              final n = int.parse(value);
              if (n == 0 || n >= widget.maxPage) {
                setState(() {
                  errorText = 'Number Range 1-${widget.maxPage}';
                });
                return;
              }
              setState(() {
                errorText = null;
              });
            },
          ),
        ],
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: col.surface,
            foregroundColor: col.onSurface,
          ),
          onPressed: () {
            context.pop();
          },
          child: Text('Close'),
        ),
        FilledButton(
          onPressed: errorText != null
              ? null
              : () {
                  context.pop<int>(int.parse(controller.text));
                },
          child: Text('Jump Page'),
        ),
      ],
    );
  }
}
