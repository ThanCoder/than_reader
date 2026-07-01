import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/utils/utils.dart';

class CacheManagerListTile extends StatefulWidget {
  final String cacheDirPath;
  const CacheManagerListTile({super.key, required this.cacheDirPath});

  @override
  State<CacheManagerListTile> createState() => _CacheManagerListTileState();
}

class _CacheManagerListTileState extends State<CacheManagerListTile> {
  bool needToClean = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Utils().getFolderInfo(Directory(widget.cacheDirPath)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Text('စစ်ဆေးနေပါတယ်.....');
        }
        final data = snapshot.data;
        if (data == null) return SizedBox.shrink();
        needToClean = data.$1 > 0;

        return Card(
          child: ListTile(
            leading: Icon(Icons.cleaning_services_sharp),
            title: Text(
              'Cache: Count: ${data.$1} - Size: ${data.$2.fileSizeLabel()}',
            ),
            onTap: _showCaleanConfirm,
          ),
        );
      },
    );
  }

  void _showCaleanConfirm() {
    showTConfirmDialog(
      context,
      contentText: 'Cache: ရှင်းချင်ပါသလား?',
      submitText: 'Clean Cache',
      onSubmit: () async {
        await Utils.instance.deleteFolder(Directory(widget.cacheDirPath));
        if (!mounted) return;
        setState(() {});
      },
    );
  }
}
