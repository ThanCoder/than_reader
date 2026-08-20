import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => SuccessAlertDialog(message: message),
  );
}

class SuccessAlertDialog extends StatelessWidget {
  final String message;
  const SuccessAlertDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      title: Text('Success', style: TextStyle(color: col.primary)),
      backgroundColor: col.surfaceContainer,
      content: SelectableText(
        message,
        style: TextStyle(color: col.onSurfaceVariant),
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
      ],
    );
  }
}
