import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/menu_item.dart';

class ShareDownloadMenu extends StatelessWidget {
  const new({super.key, required this.file});
  final ReaderFile file;

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          MenuItem(title: file.name, leadingIcon: Icons.title_outlined),

          MenuItem(
            title: file.configId,
            leadingIcon: Icons.fingerprint_outlined,
          ),
          MenuItem(
            title: file.date.toTimeAgo(),
            leadingIcon: Icons.date_range_outlined,
          ),
          MenuItem(
            title: file.size.fileSizeLabel(),
            leadingIcon: Icons.storage_outlined,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                Icons.download,
                color: col.onPrimary.withValues(alpha: .45),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                color: col.onPrimary.withValues(alpha: .60),
              ),
              title: Text('Download', style: TextStyle(color: col.onPrimary)),
              tileColor: col.primary,
              shape: RoundedRectangleBorder(borderRadius: .circular(15)),
              onTap: () {
                context.pop<ReaderFile>(file);
              },
            ),
          ),
        ],
      ),
    );
  }
}
