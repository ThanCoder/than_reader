import 'package:flutter/material.dart';

enum ListStyleButtonType {
  list,
  grid;

  static ListStyleButtonType fromName(String type) {
    if (type == grid.name) return grid;
    return list;
  }
}

class ListStyleButton extends StatelessWidget {
  final ListStyleButtonType value;
  final void Function(ListStyleButtonType value)? onApply;
  const ListStyleButton({super.key, required this.value, this.onApply});

  static final listStyleButtonTypeNotifier = ValueNotifier<ListStyleButtonType>(
    .list,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: listStyleButtonTypeNotifier,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            if (value == .list) {
              listStyleButtonTypeNotifier.value = .grid;
            } else if (value == .grid) {
              listStyleButtonTypeNotifier.value = .list;
            }
          },
          icon: iconWidget,
        );
      },
    );
  }

  Widget get iconWidget {
    if (listStyleButtonTypeNotifier.value == .grid) {
      return Icon(Icons.grid_view_rounded);
    }
    return Icon(Icons.list_rounded);
  }
}
