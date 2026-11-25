import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';

class NovelUtil {
  static final NovelUtil instance = NovelUtil._();
  NovelUtil._();
  factory NovelUtil() => instance;

  File getCoverCacheFile(NovelFile file) =>
      File(AppUtil.instance.getCachePath('${file.name.onlyName}.png'));

  Future<void> genThumbnail(NovelFile file) async {
    final coverFile = getCoverCacheFile(file);

    if (coverFile.existsSync()) return;
    final store = DualStore();
    await store.open(file.path);
    final res = await store.imageBox.getOne();
    if (res != null) {
      final bytes = await res.imageData;
      if (bytes != null) {
        await coverFile.writeAsBytes(bytes);
      }
    }

    await store.close();
  }
}
