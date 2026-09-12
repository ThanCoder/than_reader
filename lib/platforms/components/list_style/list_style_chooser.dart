import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
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
    return StreamBuilder(
      stream: CFBStore.instance.stream.put.where(
        (e) => e.key == appListStyleKey,
      ),
      builder: (context, asyncSnapshot) {
        final current = ListStyleType.fromVal(
          CFBStore.instance.getString(appListStyleKey),
        );
        return IconButton(
          style: IconButton.styleFrom(
            backgroundColor: col.surfaceContainerHighest,
            foregroundColor: col.onSurface,
          ),
          icon: Icon(current.iconData),
          onPressed: () {
            final next = (current.index + 1) % ListStyleType.values.length;
            CFBStore.instance.put(
              appListStyleKey,
              ListStyleType.values[next].name,
            );
          },
        );
      },
    );
  }

  // void showStyle() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     showDragHandle: true,
  //     builder: (context) => ListStyleMenu(),
  //   );
  // }
}
