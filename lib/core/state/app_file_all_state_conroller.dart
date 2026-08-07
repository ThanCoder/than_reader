import 'dart:async';
import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/state/app_file_state.dart';
import 'package:than_reader/core/state/app_file_sort_controller.dart';
import 'package:than_reader/core/state/pdf_state_event.dart';
import 'package:than_reader/core/utils/file_scanner.dart';
import 'package:than_reader/core/utils/pdf_tag_db.dart';
import 'package:than_reader/partials/sort_provider.dart';

class AppFileAllStateConroller {
  static AppFileAllStateConroller instance = AppFileAllStateConroller._();
  AppFileAllStateConroller._();
  factory AppFileAllStateConroller() => instance;

  final _controller = StreamController<AppFileState>.broadcast();
  Stream<AppFileState> get stream => _controller.stream;
  final Set<String> _allTags = {};
  Set<String> get allTags => _allTags;
  // List<AppFile> _allFiles = [];

  AppFileState _state = .empty();
  AppFileState get state => _state;

  final _sortController = AppFileSortController.instance;
  SortItem get sortItem => _sortController.currentItem;
  List<SortItem> get sortList => _sortController.sortList;
  Set<FileType> fileTypes = {};

  Future<void> init() async {
    _sortController.stream.listen((event) {
      sort();
    });

    _sortController.init();
  }

  Future<void> fetchList() async {
    try {
      _state = _state.copyWith(isLoading: true, error: '', list: []);
      _controller.add(_state);

      final allFiles = await FileScanner.getAll();
      for (var file in allFiles) {
        fileTypes.add(file.type);
      }
      _state = _state.copyWith(isLoading: false, error: '', list: allFiles);
      sort();
      // add alltags
      refreshAllTags();
      _controller.add(_state);
      sort();
    } catch (e) {
      debugPrint('[AppFileAllStateConroller:fetchList]: $e');
      _state = _state.copyWith(isLoading: false, error: e.toString());
      _controller.add(_state);
    }
  }

  void setSort(SortItem item) {
    _sortController.setSort(item);
  }

  void sort() {
    _sortController.sort(_state.list);
    _controller.add(_state);
  }

  void refreshState() {
    _controller.add(_state);
  }

  List<AppFile> getFilterTag(String tag) {
    List<AppFile> list = [];
    for (var pdf in state.list) {
      final tags = PdfTagDB.instance.getList(pdf.path);
      if (tags.contains(tag)) {
        list.add(pdf);
      }
    }
    return list;
  }

  void refreshAllTags() {
    _allTags.clear();
    for (var pdf in state.list) {
      final tags = PdfTagDB.instance.getList(pdf.path);
      _allTags.addAll(tags);
    }
    _controller.add(state);
  }

  void dispatch(PdfStateEvent event) {
    if (event is PdfDelete) {
      _handleDeletePdf(event);
    }
  }

  void _handleDeletePdf(PdfDelete event) {
    final list = state.list;
    final index = list.indexWhere((e) => e.path == event.pdf.path);
    if (index == -1) return;
    // ui
    list.removeAt(index);
    _state = _state.copyWith(list: list);
    _controller.add(_state);
    //disk
    final file = File(event.pdf.path);
    final configFile = File(event.pdf.configPath);

    if (file.existsSync()) {
      file.deleteSync();
    }
    if (configFile.existsSync()) {
      configFile.deleteSync();
    }
  }

  void renamePdf(AppFile pdf, String rename) {
    final oldPdf = File(pdf.path);

    final renamePath = PathBuf(oldPdf.parentPath).join('$rename.pdf').path;
    // pdf အရင်ပြောင်း
    if (oldPdf.existsSync()) oldPdf.renameSync(renamePath);

    // new class ပြောင်း
    final newPdf = pdf.copyWith(path: renamePath, name: renamePath.getName());
    // ပြီးတော့ List မှာပြောင်း
    final newList = List<AppFile>.from(state.list);
    final index = newList.indexWhere((e) => e.name == pdf.name);
    if (index == -1) {
      debugPrint(
        '[AppFileAllStateConroller:renamePdf]: ${pdf.name} not found index',
      );
      return;
    }
    newList[index] = newPdf;
    _controller.add(_state.copyWith(list: newList));
  }
}
