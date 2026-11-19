import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/novel_util.dart';

class NovelThumbItem extends StatefulWidget {
  const new({super.key, required this.file});
  final NovelFile file;

  @override
  State<NovelThumbItem> createState() => _NovelThumbItemState();
}

class _NovelThumbItemState extends State<NovelThumbItem> {
  late final thumbFile = File(
    AppUtil.instance.getCachePath('${widget.file.name.onlyName}.png'),
  );

  @override
  Widget build(BuildContext context) {
    if (thumbFile.existsSync()) {
      return Image.file(
        thumbFile,
        fit: .cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/logo/DualStore Dual-Database Logo.png'),
      );
    }

    return FutureBuilder(
      future: NovelUtil.genThumbnail(widget.file, thumbFile),
      builder: (context, snapshot) {
        if (snapshot.connectionState == .waiting) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return Image.file(
          thumbFile,
          fit: .cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset('assets/logo/DualStore Dual-Database Logo.png'),
        );
      },
    );
  }
}
