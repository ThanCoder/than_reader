import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/list_style/list_style_type.dart';

class GroupListStyleProvider extends StatelessWidget {
  const GroupListStyleProvider({
    super.key,
    required this.list,
    required this.gridBuilder,
    required this.listBuilder,
  });
  final List<ReaderFile> list;
  final Widget Function(
    BuildContext context,
    Map<String, List<ReaderFile>> groups,
  )
  gridBuilder;
  final Widget Function(
    BuildContext context,
    Map<String, List<ReaderFile>> groups,
  )
  listBuilder;

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<ReaderFile>>{};
    for (var book in list) {
      groups.putIfAbsent(book.parentPath.onlyName, () => []).add(book);
    }
    return StreamBuilder(
      stream: CFBStore.instance.stream.put.where(
        (e) => e.key == appListStyleKey,
      ),
      builder: (context, asyncSnapshot) {
        final current = ListStyleType.fromVal(
          CFBStore.instance.getString(appListStyleKey),
        );
        if (current == .list) {
          return listBuilder(context, groups);
        }
        return gridBuilder(context, groups);
      },
    );
  }
}
