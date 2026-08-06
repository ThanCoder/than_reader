import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';

class TocDrawer extends StatelessWidget {
  final List<EpubTocItem> list;
  final EpubTocItem? currentItem;
  final void Function(EpubTocItem item)? onClicked;
  const TocDrawer({
    super.key,
    required this.list,
    this.currentItem,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _TocItem(
              item: list[index],
              onClicked: (item) {
                onClicked?.call(item);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}

class _TocItem extends StatelessWidget {
  final EpubTocItem item;
  final int depth;
  final void Function(EpubTocItem item)? onClicked;
  const _TocItem({required this.item, this.depth = 0, this.onClicked});

  @override
  Widget build(BuildContext context) {
    final hasChildren = item.children.isNotEmpty;

    if (hasChildren) {
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: 16.0 + depth * 12, right: 16),
        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        children: [
          for (final child in item.children)
            _TocItem(item: child, depth: depth + 1),
        ],
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.only(left: 32.0 + depth * 12, right: 16),
      title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () {
        onClicked?.call(item);
      },
    );
  }
}

// class _TocItem extends StatelessWidget {
//   final EpubTocItem item;

//   const _TocItem({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     if (item.children.isEmpty) {
//       return ListTile(
//         title: Text(item.title),
//         onTap: () {
//           print(item);
//         },
//       );
//     }

//     return ExpansionTile(
//       title: Text(item.title),
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 16),
//           child: Column(
//             children: [
//               for (final child in item.children) _TocItem(item: child),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
