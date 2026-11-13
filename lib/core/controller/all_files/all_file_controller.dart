import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_reader/core/controller/all_files/all_file_state.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/reader_config/reader_config_util.dart';
import 'package:than_reader/core/utils/file_scanner.dart';
import 'package:than_reader/ui/sort_provider/sort_provider.dart';

/// ***********Events******************
class AllFileControllerLoaded extends IControllerEvent {}

class AllFileControllerDeleted extends IControllerEvent {
  final ReaderFile file;
  const AllFileControllerDeleted(this.file);
}

class AllFileControllerError extends IControllerEvent {
  final String message;
  const AllFileControllerError(this.message);
}

class AllFileControllerLoading extends IControllerEvent {}

class AllFileControllerStateChanged extends IControllerEvent {}

class AllFileControllerSortChanged extends IControllerEvent {}

class AllFileControllerConfigStateChanged extends IControllerEvent {
  final String? configId;
  const new(this.configId);
}

/// ***********Events******************

class AllFileController extends IController {
  @override
  Future<void> init() async {
    ReaderConfigUtil.instance.events.listen((configId) async {
      final file = map[configId];
      if (file == null) return;
      final cf = await ReaderConfigUtil.instance.getPdfConfigOrNull(file);
      if (cf == null) return;
      if (cf.isAdult) {
        adultBook.add(configId);
      } else {
        adultBook.remove(configId);
      }
      if (cf.isCompleted) {
        completedBook.add(configId);
      } else {
        completedBook.remove(configId);
      }

      addEvent(AllFileControllerConfigStateChanged(configId));
    });
  }

  List<ReaderFile> _list = [];
  List<ReaderFile> get list => _list;
  final Map<String, ReaderFile> map = {};

  final Set<String> adultBook = {};
  final Set<String> completedBook = {};

  List<ReaderFile> get toAdultBooks {
    final res = <ReaderFile>[];
    for (var id in adultBook) {
      final book = map[id];
      if (book == null) continue;
      res.add(book);
    }
    return res;
  }

  List<ReaderFile> get toCompletedBooks {
    final res = <ReaderFile>[];
    for (var id in completedBook) {
      final book = map[id];
      if (book == null) continue;
      res.add(book);
    }
    return res;
  }

  final cf = CFBStore.instance;
  static const String sortIdKey = 'all-file-sort-id-key';
  static const String sortIsTRueKey = 'all-file-sort-is-true-key';

  AllFileState _state = .new(isLoading: false);
  AllFileState get state => _state;

  Future<void> loadAll({bool useCache = true}) async {
    try {
      _state = _state.copyWith(isLoading: true);
      addEvent(AllFileControllerLoading());
      _list = await FileScanner.scanAll();

      map.clear();

      for (var f in _list) {
        map[f.configId] = f;
      }

      _state = _state.copyWith(isLoading: false);

      // check sort
      final sortId = cf.getInt(sortIdKey);
      final sortIsTrue = cf.getBool(sortIsTRueKey);
      final curSort = geSortItem(sortId, sortIsTrue);
      if (curSort != null) {
        currentSort = curSort;
        onSort();
      }

      _fetchConfig();

      addEvent(AllFileControllerLoaded());
      addEvent(AllFileControllerStateChanged());
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      addEvent(AllFileControllerError(e.toString()));
    }
  }

  void _fetchConfig() async {
    adultBook.clear();
    completedBook.clear();

    for (var e in map.entries) {
      final key = e.key;
      final value = e.value;

      final cf = await ReaderConfigUtil.instance.getPdfConfigOrNull(value);
      if (cf != null) {
        if (cf.isAdult) {
          adultBook.add(key);
        }
        if (cf.isCompleted) {
          completedBook.add(key);
        }
      }
    }

    addEvent(AllFileControllerConfigStateChanged(null));
  }

  //*****************sort*******************************
  final sortList = <SortItem>[.nameItem, .dateItem, .sizeItem];
  SortItem currentSort = .dateItem;
  void setSort(SortItem item) {
    currentSort = item;
    onSort();
    addEvent(AllFileControllerStateChanged());
    cf.put(sortIdKey, item.id).put(sortIsTRueKey, item.isTrue).writeAll();
  }

  void onSort() {
    if (currentSort.id == SortItem.nameItem.id) {
      list.sortA2Z(a2z: currentSort.isTrue);
    }
    if (currentSort.id == SortItem.dateItem.id) {
      list.sortDate(new2old: currentSort.isTrue);
    }
    if (currentSort.id == SortItem.sizeItem.id) {
      list.sortSize(small2big: currentSort.isTrue);
    }
  }

  SortItem? geSortItem(int sortId, bool isTrue) {
    if (sortId == SortItem.nameItem.id) {
      return SortItem.nameItem.copyWith(isTrue: isTrue);
    }
    if (sortId == SortItem.dateItem.id) {
      return SortItem.dateItem.copyWith(isTrue: isTrue);
    }
    if (sortId == SortItem.sizeItem.id) {
      return SortItem.sizeItem.copyWith(isTrue: isTrue);
    }
    return null;
  }

  ReaderFile? getById(String configId) {
    final index = list.indexWhere((e) => e.configId == configId);
    if (index != -1) {
      return list[index];
    }
    return null;
  }

  void deleteForever(ReaderFile file) async {
    final index = list.indexWhere((e) => e.path == file.path);
    if (index == -1) return;
    list.removeAt(index);
    map.remove(file.configId);

    // remove disk
    final f = File(file.path);
    if (f.existsSync()) {
      await f.delete();
    }
    adultBook.remove(file.configId);
    completedBook.remove(file.configId);

    addEvent(AllFileControllerLoaded());
    addEvent(AllFileControllerDeleted(file));
    addEvent(AllFileControllerConfigStateChanged(file.configId));
  }

  void rename(ReaderFile file, String renamedName) async {
    final index = list.indexWhere((e) => e.path == file.path);
    if (index == -1) return;
    if (file.name == renamedName) return;

    final newPath = file.parentPath.join('$renamedName.${file.type.extname}');

    // print('old: ${file.path}');
    // print('newPath: $newPath');

    final f = File(file.path);
    if (f.existsSync()) {
      await f.rename(newPath);
    }

    final changedFile = file.copyWith(name: renamedName, path: newPath);
    list[index] = changedFile;

    addEvent(AllFileControllerLoaded());
    addEvent(AllFileControllerDeleted(file));
  }
}
