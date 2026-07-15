import 'package:than_reader/modules_apps/pdf_modules/cbf_config_storage.dart';
import 'package:than_reader/modules_apps/pdf_modules/interfaces/i_config_storage.dart';

class ConfigStorageFactory {
  static IConfigStorage create(String path) {
    return CbfConfigStorage(path);
    // return JsonConfigStorage(path);
  }
}
