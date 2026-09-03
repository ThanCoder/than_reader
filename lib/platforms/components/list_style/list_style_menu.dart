import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/list_style/list_style_type.dart';

class ListStyleMenu extends StatefulWidget {
  const ListStyleMenu({super.key});

  @override
  State<ListStyleMenu> createState() => _ListStyleMenuState();
}

class _ListStyleMenuState extends State<ListStyleMenu> {
  final list = ListStyleType.values;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: CFBStore.instance.stream.put.where(
          (e) => e.key == appListStyleKey,
        ),
        builder: (context, asyncSnapshot) {
          final current = ListStyleType.fromVal(
            CFBStore.instance.getString(appListStyleKey),
          );
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              children: [
                ...list.map((e) => _item(e, current)),
                SizedBox(height: 50),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _item(ListStyleType type, ListStyleType current) {
    final col = Theme.of(context).colorScheme;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      tileColor: col.surfaceContainer,
      leading: Container(
        padding: .all(5),
        decoration: BoxDecoration(
          color: col.tertiaryContainer,
          borderRadius: .circular(15),
        ),
        child: Icon(type.iconData, color: col.onTertiaryContainer),
      ),
      title: Text(type.lable),
      trailing: type != current ? null : Icon(Icons.check_box_rounded),
      onTap: () {
        CFBStore.instance.putAndWriteAll(appListStyleKey, type.name);
      },
    );
  }
}
