import 'package:than_reader/modules_apps/reader/pdf_readers/cbf_config_storage.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/interfaces/i_config_storage.dart';

class ConfigStorageFactory {
  static IConfigStorage create(String path) {
    return CbfConfigStorage(path);
    // return JsonConfigStorage(path);
  }
}
