import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/reader_tracker/reader_tracker_page.dart';

class ReaderTrackerListTile extends StatelessWidget {
  const ReaderTrackerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: .symmetric(vertical: 10, horizontal: 12),
      tileColor: col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Container(
        padding: .all(10),
        decoration: BoxDecoration(
          color: col.tertiaryContainer,
          borderRadius: .circular(15),
        ),
        child: Icon(
          Icons.track_changes_outlined,
          color: col.onTertiaryContainer,
        ),
      ),
      title: Text('Reader Tracker'),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () {
        context.pushMaterialPageRoute(
          builder: (mainCtx) => ReaderTrackerPage(),
        );
      },
    );
  }
}
