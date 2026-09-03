import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/platforms/components/list_style/list_style_type.dart';

class ListStyleProvider extends StatelessWidget {
  const ListStyleProvider({
    super.key,
    required this.gridBuilder,
    required this.listBuilder,
  });

  final Widget Function(BuildContext context) gridBuilder;
  final Widget Function(BuildContext context) listBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CFBStore.instance.stream.put.where(
        (e) => e.key == appListStyleKey,
      ),
      builder: (context, asyncSnapshot) {
        final current = ListStyleType.fromVal(
          CFBStore.instance.getString(appListStyleKey),
        );
        if (current == .list) {
          return listBuilder(context);
        }
        return gridBuilder(context);
      },
    );
  }
}
