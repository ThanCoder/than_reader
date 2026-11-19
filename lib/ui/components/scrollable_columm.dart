import 'package:material_ui/material_ui.dart';

class ScrollableColumn extends StatelessWidget {
  const new({
    super.key,
    required this.children,
    this.spacing = 8,
    this.padding = const EdgeInsets.all(8.0),
    this.mainAxisAlignment = .start,
    this.crossAxisAlignment = .center,
  });
  final List<Widget> children;
  final double spacing;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          spacing: spacing,
          children: children,
        ),
      ),
    );
  }
}
