import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/list_style/group_list_type.dart';

class GroupListStyleMenu extends StatefulWidget {
  const GroupListStyleMenu({super.key});

  @override
  State<GroupListStyleMenu> createState() => _GroupListStyleMenuState();
}

class _GroupListStyleMenuState extends State<GroupListStyleMenu> {
  final list = GroupListType.values;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: CFBStore.instance.stream.put.where(
          (e) => e.key == appGropListStyleKey,
        ),
        builder: (context, asyncSnapshot) {
          final current = GroupListType.fromVal(
            CFBStore.instance.getString(appGropListStyleKey),
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

  Widget _item(GroupListType type, GroupListType current) {
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
        child: Icon(type.iconData),
      ),
      title: Text(type.lable),
      trailing: type != current ? null : Icon(Icons.check_box_rounded),
      onTap: () {
        CFBStore.instance.putAndWriteAll(appGropListStyleKey, type.name);
      },
    );
  }
}
