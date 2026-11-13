import 'package:material_ui/material_ui.dart';

class TChip extends StatelessWidget {
  final Widget title;
  final Widget? avatar;
  final MouseCursor? mouseCursor;
  final Color? backgroundColor;
  final void Function()? onClick;
  final void Function()? onDelete;
  const TChip({
    super.key,
    required this.title,
    this.backgroundColor,
    this.avatar,
    this.onClick,
    this.onDelete,
    this.mouseCursor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Chip(
        backgroundColor: backgroundColor,
        mouseCursor: mouseCursor ?? SystemMouseCursors.click,
        deleteIconColor: Colors.red[900],
        label: title,
        avatar: avatar,
        onDeleted: onDelete,
      ),
    );
  }
}
