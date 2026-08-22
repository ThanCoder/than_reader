import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/all_files/all_file_state.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/file_scanner.dart';

/// ***********Events******************
class AllFileControllerLoaded extends IControllerEvent {}

class AllFileControllerDeleted extends IControllerEvent {
  final ReaderFile file;
  const AllFileControllerDeleted(this.file);
}

class AllFileControllerError extends IControllerEvent {
  final String message;
  AllFileControllerError(this.message);
}

class AllFileControllerLoading extends IControllerEvent {}

class AllFileControllerStateChanged extends IControllerEvent {}

/// ***********Events******************

class AllFileController extends IController {
  @override
  Future<void> init() async {}

  List<ReaderFile> _list = [];
  List<ReaderFile> get list => _list;

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
      _state = _state.copyWith(isLoading: false);

      // check sort
      final sortId = cf.getInt(sortIdKey);
      final sortIsTrue = cf.getBool(sortIsTRueKey);
      final curSort = getSortItem(sortId, sortIsTrue);
      if (curSort != null) {
        currentSort = curSort;
        onSort();
      }

      addEvent(AllFileControllerLoaded());
      addEvent(AllFileControllerStateChanged());
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      addEvent(AllFileControllerError(e.toString()));
    }
  }

  final sortList = <TSortItem>[.nameTSortItem, .dateTSortItem, .sizeTSortItem];
  TSortItem currentSort = .dateTSortItem;
  void setSort(TSortItem item) {
    currentSort = item;
    onSort();
    addEvent(AllFileControllerStateChanged());
    cf.put(sortIdKey, item.id).put(sortIsTRueKey, item.isTrue).writeAll();
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

    // remove disk
    final f = File(file.path);
    if (f.existsSync()) {
      await f.delete();
    }

    addEvent(AllFileControllerLoaded());
    addEvent(AllFileControllerDeleted(file));
  }

  void onSort() {
    if (currentSort.id == TSortItem.nameTSortItem.id) {
      list.sortA2Z(a2z: currentSort.isTrue);
    }
    if (currentSort.id == TSortItem.dateTSortItem.id) {
      list.sortDate(new2old: currentSort.isTrue);
    }
    if (currentSort.id == TSortItem.sizeTSortItem.id) {
      list.sortSize(small2big: currentSort.isTrue);
    }
  }

  TSortItem? getSortItem(int sortId, bool isTrue) {
    if (sortId == TSortItem.nameTSortItem.id) {
      return TSortItem.nameTSortItem.copyWith(isTrue: isTrue);
    }
    if (sortId == TSortItem.dateTSortItem.id) {
      return TSortItem.dateTSortItem.copyWith(isTrue: isTrue);
    }
    if (sortId == TSortItem.sizeTSortItem.id) {
      return TSortItem.sizeTSortItem.copyWith(isTrue: isTrue);
    }
    return null;
  }
}
