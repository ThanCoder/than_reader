import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';

class ReaderFileRecentController {
  static ReaderFileRecentController instance = ReaderFileRecentController._();
  ReaderFileRecentController._();
  factory ReaderFileRecentController() => instance;

  final _db = CFBStore();

  Stream<StoreEvent> get events => _db.events;

  Future<void> init(String dbPath) async {
    await _db.open(dbPath);
  }

  void addList(String value) {
    final res = list;
    res.remove(value);
    res.insert(0, value);

    _db.putAndWriteAll('list', res);
  }

  List<String> get list => _db.getStringList('list');

  List<ReaderFile> get files {
    final res = ReaderFileAllStateConroller.instance.state.list;
    return res.where((e) {
      if (list.contains(e.path)) {
        final f = File(e.path);
        return f.existsSync();
      }
      return false;
    }).toList();
  }
}
