import 'package:flutter/material.dart';

enum GroupListType {
  all,
  folderGroup;

  String get lable {
    if (this == all) return 'All';
    return 'Folder Group';
  }

  IconData get iconData {
    if (this == folderGroup) {
      return Icons.folder;
    }
    return Icons.book;
  }

  static GroupListType fromVal(String val) {
    return values.firstWhere((e) => e.name == val, orElse: () => .all);
  }
}
