import 'package:material_ui/material_ui.dart';

class RefreshButton extends StatelessWidget {
  final Widget text;
  final Widget? icon;
  final void Function()? onClicked;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final double spacing;
  const RefreshButton({
    super.key,
    required this.text,
    this.onClicked,
    this.icon,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      spacing: spacing,
      children: [
        text,
        IconButton(
          mouseCursor: onClicked == null ? null : SystemMouseCursors.click,
          onPressed: onClicked,
          icon: icon ?? Icon(Icons.refresh, color: Colors.blue),
        ),
      ],
    );
  }
}
