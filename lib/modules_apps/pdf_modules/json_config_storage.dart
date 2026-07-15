// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:than_reader/modules_apps/pdf_modules/interfaces/i_config_storage.dart';

class JsonConfigStorage implements IConfigStorage {
  final String path;
  JsonConfigStorage(this.path);

  @override
  Map<String, dynamic> loadSync() {
    try {
      final configFile = File('$path.json');
      if (!configFile.existsSync()) return {};
      return jsonDecode(configFile.readAsStringSync());
    } catch (e) {
      print('[JsonConfigStorage:loadSync]: $e');
      return {};
    }
  }

  @override
  void saveSync(Map<String, dynamic> map) {
    final configFile = File('$path.json');
    configFile.writeAsStringSync(jsonEncode(map));
  }

  @override
  Future<Map<String, dynamic>> load() async {
    try {
      final configFile = File('$path.json');
      if (!configFile.existsSync()) return {};
      return jsonDecode(await configFile.readAsString());
    } catch (e) {
      print('[JsonConfigStorage:load]: $e');
      return {};
    }
  }

  @override
  Future<void> save(Map<String, dynamic> map) async {
    final configFile = File('$path.json');
    await configFile.writeAsString(jsonEncode(map));
  }
}
