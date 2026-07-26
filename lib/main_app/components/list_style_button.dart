import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';

enum ListStyleButtonType {
  list,
  grid;

  IconData get iconData {
    if (this == grid) {
      return Icons.grid_view_rounded;
    }
    return Icons.list;
  }

  int get currentIndex => values.indexWhere((e) => e == this);

  static ListStyleButtonType fromName(String type) {
    return values.firstWhere((e) => e.name == type, orElse: () => list);
  }
}

class ListStyleButton extends StatefulWidget {
  const ListStyleButton({super.key});

  static final valueNotifier = ValueNotifier<ListStyleButtonType>(.list);

  static void init() {
    final val = CFBStore.getInstance.getString('ListStyleButton');
    valueNotifier.value = ListStyleButtonType.fromName(val);
  }

  static void setValue(ListStyleButtonType val) {
    valueNotifier.value = val;
    CFBStore.getInstance.put('ListStyleButton', val.name);
    CFBStore.getInstance.writeAll();
  }

  @override
  State<ListStyleButton> createState() => _ListStyleButtonState();
}

class _ListStyleButtonState extends State<ListStyleButton> {
  @override
  void initState() {
    ListStyleButton.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ListStyleButton.valueNotifier,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () {
            int curIndex = ListStyleButton.valueNotifier.value.currentIndex;
            curIndex = (curIndex + 1) % ListStyleButtonType.values.length;
            ListStyleButton.setValue(ListStyleButtonType.values[curIndex]);
          },
          icon: Icon(value.iconData),
        );
      },
    );
  }
}
