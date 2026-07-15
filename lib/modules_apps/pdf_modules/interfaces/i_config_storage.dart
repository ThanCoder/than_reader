abstract class IConfigStorage {
  Map<String, dynamic> loadSync();
  void saveSync(Map<String, dynamic> map);

  Future<Map<String, dynamic>> load();
  Future<void> save(Map<String, dynamic> map);
}
