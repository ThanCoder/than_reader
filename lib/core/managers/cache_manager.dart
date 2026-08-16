import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class CacheManager {
  static String getReaderFileCachePath(ReaderFile file) {
    return AppUtils.instance.getCachePath('${file.configId}.jpg');
  }
}
