import 'package:material_ui/material_ui.dart';
import 'package:than_reader/ui/build_context_x.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => ErrorAlertDialog(message: message),
  );
}

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;

    return AlertDialog.adaptive(
      scrollable: true,
      title: Text('Error', style: TextStyle(color: col.error)),
      backgroundColor: col.errorContainer,
      content: SelectableText(
        message,
        style: TextStyle(color: col.onErrorContainer),
      ),
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: col.error,
            foregroundColor: col.onError,
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
