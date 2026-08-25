import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

Future<bool> showPromptAlertDialog(
  BuildContext context,
  String promptText, {
  bool barrierDismissible = true,
  String? confirmText,
  String? closeText,
  String? title,
  Color? confirmColor,
  Color? confirmForegroundColor,
  Color? closeColor,
  Color? closeForegroundColor,
  final String? Function(String text)? onErrorCheck,
}) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => PromptAlertDialog(
      promptText: promptText,
      title: title,
      closeText: closeText,
      confirmText: confirmText,
      confirmColor: confirmColor,
      confirmForegroundColor: confirmForegroundColor,
      closeColor: closeColor,
      closeForegroundColor: closeForegroundColor,
      onErrorCheck: onErrorCheck,
    ),
  );
  return res ?? false;
}

class PromptAlertDialog extends StatefulWidget {
  const PromptAlertDialog({
    super.key,
    required this.promptText,
    this.confirmText,
    this.closeText,
    this.title,
    this.confirmColor,
    this.confirmForegroundColor,
    this.closeColor,
    this.closeForegroundColor,
    this.onErrorCheck,
  });

  final String promptText;
  final String? confirmText;
  final String? closeText;
  final String? title;

  final Color? confirmColor;
  final Color? confirmForegroundColor;
  final Color? closeColor;
  final Color? closeForegroundColor;
  final String? Function(String text)? onErrorCheck;

  @override
  State<PromptAlertDialog> createState() => _PromptAlertDialogState();
}

class _PromptAlertDialogState extends State<PromptAlertDialog> {
  final con = TextEditingController();
  final focusNode = FocusNode();
  @override
  void initState() {
    con.text = widget.promptText;
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    con.dispose();
    focusNode.dispose();
    super.dispose();
  }

  ColorScheme get col => Theme.of(context).colorScheme;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(
        widget.title ?? 'Prompt',
        style: TextStyle(color: col.onSurface),
      ),
      scrollable: true,
      backgroundColor: col.surface,
      content: _formWidget,
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.closeColor ?? col.surfaceContainer,
            foregroundColor: widget.closeForegroundColor ?? col.onSurface,
          ),
          onPressed: () {
            context.pop();
          },
          child: Text(widget.closeText ?? 'Close'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: widget.confirmColor ?? col.primaryContainer,
            foregroundColor:
                widget.confirmForegroundColor ?? col.onPrimaryContainer,
          ),
          onPressed: errorText != null
              ? null
              : () {
                  context.pop<String>(con.text);
                },
          child: Text(widget.confirmText ?? 'Confirm'),
        ),
      ],
    );
  }

  Widget get _formWidget {
    return TextField(
      controller: con,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: (value) {
        final res = widget.onErrorCheck?.call(value);
        if (res != null) {
          errorText = res;
          setState(() {});
          return;
        }
        if (errorText != null) {
          setState(() {
            errorText = null;
          });
        }
      },
      onSubmitted: (value) {
        if (errorText != null) return;
        Navigator.pop<String>(context, con.text);
      },
    );
  }
}
