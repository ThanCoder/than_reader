import 'package:dual_store/dual_store.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';

class ReaderInfoStore {
  static final ReaderInfoStore instance = ReaderInfoStore._();
  ReaderInfoStore._();
  factory ReaderInfoStore() => instance;

  final store = DualStore();

  DuBox<ReaderInfo> get infoBox => store.getBox<ReaderInfo>();

  Future<void> init(String dbPath) async {
    store.registerAdapter(ReaderInfoAdapter());
    await store.open(dbPath);
  }
}
