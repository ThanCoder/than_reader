import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/list_style/list_style_menu.dart';
import 'package:than_reader/platforms/components/list_style/list_style_type.dart';

class ListStyleChooser extends StatefulWidget {
  const ListStyleChooser({super.key});

  @override
  State<ListStyleChooser> createState() => _ListStyleChooserState();
}

class _ListStyleChooserState extends State<ListStyleChooser> {
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
          (e) => e.key == appListStyleKey,
        ),
        builder: (context, asyncSnapshot) {
          final current = ListStyleType.fromVal(
            CFBStore.instance.getString(appListStyleKey),
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
      builder: (context) => ListStyleMenu(),
    );
  }
}
