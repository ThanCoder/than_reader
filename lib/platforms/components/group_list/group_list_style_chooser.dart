import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/group_list/group_list_style_menu.dart';
import 'package:than_reader/platforms/components/list_style/group_list_type.dart';

class GroupListStyleChooser extends StatefulWidget {
  const GroupListStyleChooser({super.key});

  @override
  State<GroupListStyleChooser> createState() => _GroupListStyleChooserState();
}

class _GroupListStyleChooserState extends State<GroupListStyleChooser> {
  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: col.surfaceContainerHighest,
        foregroundColor: col.onSurface,
      ),
      icon: StreamBuilder(
        stream: CFBStore.instance.stream.put.where(
          (e) => e.key == appGropListStyleKey,
        ),
        builder: (context, asyncSnapshot) {
          final current = GroupListType.fromVal(
            CFBStore.instance.getString(appGropListStyleKey),
          );
          return Icon(current.iconData);
        },
      ),
      onPressed: showStyle,
    );
  }

  void showStyle() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => GroupListStyleMenu(),
    );
  }
}
