import 'package:flutter/material.dart';

enum ListStyleType {
  grid,
  list;

  String get lable {
    if (this == list) return 'List';
    return 'Grid';
  }

  IconData get iconData {
    if (this == list) return Icons.list_rounded;

    return Icons.grid_view_outlined;
  }

  static ListStyleType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .grid);
  }
}
