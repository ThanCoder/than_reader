// ignore_for_file: avoid_print

import 'package:dual_store/dual_store.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';

class ReaderInfoStore {
  static final ReaderInfoStore instance = ReaderInfoStore._();
  ReaderInfoStore._();
  factory ReaderInfoStore() => instance;

  final store = DualStore();

  DuBox<ReaderInfo> get infoBox => store.getBox<ReaderInfo>();

  Future<void> init(String dbPath) async {
    store.events.error.duError.listen((e) {
      print(ReaderInfoStore.instance.store.path);
      print('event: ${e.message}');
    });
    store.events.error.removeMetaError.listen((e) {
      print('event: ${e.message}');
    });
    store.registerAdapter(ReaderInfoAdapter());
    final res = await store.open(dbPath);
    if (res.isErr) {
      print('Open Error: ${res.unwrapError()}');
    }
  }
}
