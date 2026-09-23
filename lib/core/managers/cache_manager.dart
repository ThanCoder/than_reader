import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class CacheManager {
  static String getBookThumbnailCachePath(ReaderFile file) {
    return AppUtil.instance.getCachePath('${file.configId}.jpg');
  }
}
