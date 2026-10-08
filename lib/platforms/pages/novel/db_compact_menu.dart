import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class DBCompactMenu extends StatefulWidget {
  const new({super.key, required this.store});
  final DualStore store;

  @override
  State<DBCompactMenu> createState() => _DBCompactMenuState();

  static Future<void> show(BuildContext context, DualStore store) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => DBCompactMenu(store: store),
    );
  }
}

class _DBCompactMenuState extends State<DBCompactMenu> {
  void cleanup() async {
    context.pop();
    await widget.store.compact();
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: .symmetric(vertical: 8, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: .circular(14),
                color: col.surfaceContainer,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    spacing: 10,
                    children: [
                      Text('DeletedCount: ${widget.store.state.deletedCount}'),
                      Text(
                        'Deleted Size: ${widget.store.state.deletedSize.fileSizeLabel()}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: cleanup,
                    icon: Icon(Icons.cleaning_services_outlined),
                    label: Text('Database CleanUp'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
