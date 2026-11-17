import 'dart:io';

import 'package:dual_store/dual_store.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';

class NovelUtil {
  static Future<void> genThumbnail(NovelFile file, File coverFile) async {
    if (coverFile.existsSync()) return;
    final store = DualStore();
    await store.open(file.path);
    final res = await store.getImageBox.getOne();
    if (res != null) {
      final bytes = await res.imageData;
      if (bytes != null) {
        await coverFile.writeAsBytes(bytes);
      }
    }

    await store.close();
  }
}
