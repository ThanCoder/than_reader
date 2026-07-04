import 'dart:async';
import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_state.dart';
import 'package:than_reader/core/state/pdf_state_event.dart';
import 'package:than_reader/core/utils/pdf_scanner.dart';
import 'package:than_reader/partials/sort_provider.dart';

class PdfStateConroller {
  static PdfStateConroller instance = PdfStateConroller._();
  PdfStateConroller._();
  factory PdfStateConroller() => instance;

  final _controller = StreamController<PdfState>.broadcast();
  Stream<PdfState> get stream => _controller.stream;

  PdfState _state = .empty();
  PdfState get state => _state;
  final sortList = [
    SortItem.nameSortItem,
    SortItem.dateSortItem,
    SortItem.sizeSortItem,
  ];

  Future<void> fetchList() async {
    try {
      ///Sort
      SortItem sortItem = SortItem.dateSortItem;
      final id = CFBStore.getInstance.getInt('pdf_sort_id', -1);
      if (id != -1) {
        sortItem = sortList.firstWhere(
          (e) => e.id == id,
          orElse: () => SortItem.dateSortItem,
        );
        sortItem = sortItem.copyWith(
          isTrue: CFBStore.getInstance.getBool('pdf_sort_true'),
        );
      }

      _state = _state.copyWith(isLoading: true, error: '', list: []);
      _controller.add(_state);

      final list = await PdfScanner.getAll();
      _state = _state.copyWith(
        isLoading: false,
        error: '',
        list: list,
        sortItem: sortItem,
      );
      sort();
      _controller.add(_state);
      sort();
    } catch (e) {
      debugPrint('[PdfStateConroller:fetchList]: $e');
      _state = _state.copyWith(isLoading: false, error: e.toString());
      _controller.add(_state);
    }
  }

  void setSort(SortItem item) {
    _state = _state.copyWith(sortItem: item);
    CFBStore.getInstance.put('pdf_sort_id', item.id);
    CFBStore.getInstance.put('pdf_sort_true', item.isTrue);
    CFBStore.getInstance.writeAll();
    sort();
  }

  void sort() {
    if (_state.sortItem.id == SortItem.dateSortItem.id) {
      _state.list.sortDate(isNewest: state.sortItem.isTrue);
    }
    if (_state.sortItem.id == SortItem.nameSortItem.id) {
      _state.list.sortA2Z(isA2Z: state.sortItem.isTrue);
    }
    if (_state.sortItem.id == SortItem.sizeSortItem.id) {
      _state.list.sortSize(isSmallest: state.sortItem.isTrue);
    }
    _controller.add(_state);
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

  void renamePdf(PdfFile pdf, String rename) {
    final oldPdf = File(pdf.path);
    final oldConfigFile = File(pdf.configPath);

    final renamePath = oldPdf.parentPath.join('$rename.pdf');
    // pdf အရင်ပြောင်း
    if (oldPdf.existsSync()) oldPdf.renameSync(renamePath);

    // new class ပြောင်း
    final newPdf = pdf.copyWith(path: renamePath, name: renamePath.getName());
    // config name ကိုပြောင်း
    if (oldConfigFile.existsSync()) {
      oldConfigFile.renameSync(newPdf.configPath);
    }
    // ပြီးတော့ List မှာပြောင်း
    final newList = List<PdfFile>.from(state.list);
    final index = newList.indexWhere((e) => e.name == pdf.name);
    if (index == -1) {
      debugPrint('[PdfStateConroller:renamePdf]: ${pdf.name} not found index');
      return;
    }
    newList[index] = newPdf;
    _controller.add(_state.copyWith(list: newList));
  }
}
