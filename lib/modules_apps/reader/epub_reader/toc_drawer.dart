import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';

class TocDrawer extends StatefulWidget {
  final List<EpubTocItem> list;
  final String? currentSrc;
  final double recentListOffset;
  final Map<String, bool> expansionTileState;
  final void Function(String src)? onClicked;
  const TocDrawer({
    super.key,
    required this.expansionTileState,
    required this.list,
    this.recentListOffset = 0,
    this.currentSrc,
    this.onClicked,
  });

  @override
  State<TocDrawer> createState() => _TocDrawerState();

  static Map<String, bool> expansionTileStateStatic = {};
  static double recentListOffsetStatic = 0;
}

class _TocDrawerState extends State<TocDrawer> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    TocDrawer.expansionTileStateStatic = widget.expansionTileState;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      jumpItem();
    });
    controller.addListener(() {
      TocDrawer.recentListOffsetStatic = controller.offset;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void jumpItem() {
    if (widget.recentListOffset == 0) return;
    controller.animateTo(
      widget.recentListOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                final item = widget.list[index];
                return _TocItem(
                  currentSrc: widget.currentSrc,
                  item: item,
                  onClicked: (item) {
                    widget.onClicked?.call(item.src);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TocItem extends StatelessWidget {
  final String? currentSrc;
  final EpubTocItem item;
  final int depth;
  final void Function(EpubTocItem item)? onClicked;
  const _TocItem({
    required this.item,
    this.currentSrc,
    this.depth = 0,
    this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    final hasChildren = item.children.isNotEmpty;

    if (hasChildren) {
      return ExpansionTile(
        initiallyExpanded: TocDrawer.expansionTileStateStatic[item.id] ?? false,
        onExpansionChanged: (value) {
          TocDrawer.expansionTileStateStatic[item.id] = value;
        },
        textColor: currentSrc == item.src ? Colors.red : null,
        tilePadding: EdgeInsets.only(left: 16.0 + depth * 12, right: 16),
        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        children: [
          for (final child in item.children)
            _TocItem(
              item: child,
              depth: depth + 1,
              currentSrc: currentSrc,
              onClicked: onClicked,
            ),
        ],
      );
    }
    // print('$currentSrc == ${item.src}');
    return ListTile(
      textColor: currentSrc == item.src ? Colors.red : null,
      contentPadding: EdgeInsets.only(left: 32.0 + depth * 12, right: 16),
      title: Text(
        item.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14),
      ),
      onTap: () {
        onClicked?.call(item);
      },
    );
  }
}
