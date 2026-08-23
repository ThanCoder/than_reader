import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';

class FavControllerValueChanged extends IControllerEvent {}

class FavController extends IController {
  final cf = CFBStore();
  final AllFileController _allC = ControllerManager.read<AllFileController>();
  List<ReaderFile> list = [];
  List<String> idList = [];

  @override
  Future<void> init() async {
    await cf.open(
      AppUtils.instance.getPlatfromExternalConfigPath('fav.config.cfb'),
    );
    _allC.events.whereType<AllFileControllerLoaded>().listen((event) async {
      await cf.reload();
      _reload();
    });
  }

  void _reload() {
    list.clear();
    final fMap = <String, ReaderFile>{};
    for (var f in _allC.list) {
      fMap[f.configId] = f;
    }

    for (var id in cf.getList<String>('list')) {
      final file = fMap[id];
      if (file == null) continue;
      list.add(file);
    }
    idList = list.map((e) => e.configId).toList();
    addEvent(FavControllerValueChanged());
  }

  bool exists(ReaderFile file) {
    return idList.contains(file.configId);
  }

  void save() async {
    idList = list.map((e) => e.configId).toList();
    await cf.putAndWriteAll('list', idList);
    addEvent(FavControllerValueChanged());
  }

  void add(ReaderFile file) {
    final index = list.indexWhere((e) => e.path == file.path);
    if (index != -1) {
      list.removeAt(index);
    }
    list.insert(0, file);
    save();
  }

  void remove(ReaderFile file) {
    final index = list.indexWhere((e) => file.path == file.path);
    if (index != -1) {
      list.removeAt(index);
    }
    save();
  }
}
