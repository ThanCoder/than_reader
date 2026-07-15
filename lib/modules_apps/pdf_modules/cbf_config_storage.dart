import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/modules_apps/pdf_modules/interfaces/i_config_storage.dart';

class CbfConfigStorage implements IConfigStorage {
  final String path;
  CbfConfigStorage(this.path);

  @override
  Future<Map<String, dynamic>> load() async {
    final store = CFBStore();
    await store.open('$path.cbf');
    return store.getMap('data');
  }

  @override
  Map<String, dynamic> loadSync() {
    final store = CFBStore();
    store.openSync('$path.cbf');
    return store.getMap('data');
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
    final store = CFBStore();
    await store.open('$path.cbf');
    store.put('data', map);
    await store.writeAll();
  }

  @override
  void saveSync(Map<String, dynamic> map) {
    final store = CFBStore();
    store.openSync('$path.cbf');
    store.put('data', map);
    store.writeAllSync();
  }
}
