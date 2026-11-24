import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/novel_util.dart';

class NovelThumbItem extends StatefulWidget {
  const new({super.key, required this.file});
  final NovelFile file;

  @override
  State<NovelThumbItem> createState() => _NovelThumbItemState();
}

class _NovelThumbItemState extends State<NovelThumbItem> {
  late final thumbFile = NovelUtil.instance.getCoverCacheFile(widget.file);


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
      future: NovelUtil.instance.genThumbnail(widget.file),
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
