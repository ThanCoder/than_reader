import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

Future<bool> showConfirmDialog(
  BuildContext context,
  String message, {
  bool barrierDismissible = true,
  String? confirmText,
  String? closeText,
  String? title,
  Color? confirmColor,
  Color? confirmForegroundColor,
  Color? closeColor,
  Color? closeForegroundColor,
}) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ConfirmAlertDialog(
      message: message,
      title: title,
      closeText: closeText,
      confirmText: confirmText,
      confirmColor: confirmColor,
      confirmForegroundColor: confirmForegroundColor,
      closeColor: closeColor,
      closeForegroundColor: closeForegroundColor,
    ),
  );
  return res ?? false;
}

class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({
    super.key,
    required this.message,
    this.confirmText,
    this.closeText,
    this.title,
    this.confirmColor,
    this.confirmForegroundColor,
    this.closeColor,
    this.closeForegroundColor,
  });

  final String message;
  final String? confirmText;
  final String? closeText;
  final String? title;

  final Color? confirmColor;
  final Color? confirmForegroundColor;
  final Color? closeColor;
  final Color? closeForegroundColor;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return AlertDialog.adaptive(
      title: Text(title ?? 'Confirm', style: TextStyle(color: col.onSurface)),
      scrollable: true,
      backgroundColor: col.surface,
      content: Text(message, style: TextStyle(color: col.onSurface)),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: closeColor ?? col.surfaceContainer,
            foregroundColor: closeForegroundColor ?? col.onSurface,
          ),
          onPressed: () {
            context.pop<bool>(false);
          },
          child: Text(closeText ?? 'Close'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor ?? col.primaryContainer,
            foregroundColor: confirmForegroundColor ?? col.onPrimaryContainer,
          ),
          onPressed: () {
            context.pop<bool>(true);
          },
          child: Text(confirmText ?? 'Confirm'),
        ),
      ],
    );
  }
}
