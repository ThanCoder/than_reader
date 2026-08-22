import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/models/reader_history.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class ReaderHistoryControllerValueChanged extends IControllerEvent {}

class ReaderHistoryController extends IController {
  final _cf = CFBStore();
  final AllFileController _allC = ControllerManager.read<AllFileController>();
  final historyMap = <String, ReaderHistory>{};
  final allFileMap = <String, ReaderFile>{};
  int allBooks = 0;

  @override
  Future<void> init() async {
    await _cf.open(
      AppUtils.instance.getPlatfromExternalConfigPath(
        'reader.history.config.cfb',
      ),
    );
    _allC.events.whereType<AllFileControllerLoaded>().listen((event) {
      reload();
    });
  }

  Future<void> reload() async {
    historyMap.clear();
    allFileMap.clear();
    for (var f in _allC.list) {
      allFileMap[f.configId] = f;
    }

    allBooks = allFileMap.length;

    for (var map in _cf.getMapList('list')) {
      final his = ReaderHistory.fromMap(map);
      if (allFileMap.containsKey(his.fileId)) {
        historyMap[his.fileId] = his;
      }
    }
    addEvent(ReaderHistoryControllerValueChanged());
  }

  void _save() async {
    final mapList = historyMap.values.map((e) => e.toMap()).toList();
    await _cf.putAndWriteAll('list', mapList);
    addEvent(ReaderHistoryControllerValueChanged());
  }

  ReaderHistory getId(String fileId) {
    final his = historyMap[fileId];
    if (his != null) return his;
    return .empty(fileId);
  }

  void update(ReaderHistory his) {
    historyMap[his.fileId] = his;
    _save();
  }
}
