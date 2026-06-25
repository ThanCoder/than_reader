import 'dart:async';
import 'dart:io';

import 'package:cf_lite/cf_lite.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_state.dart';
import 'package:than_reader/core/state/pdf_state_event.dart';
import 'package:than_reader/core/utils/pdf_scanner.dart';

class PdfStateConroller {
  static PdfStateConroller instance = PdfStateConroller._();
  PdfStateConroller._();
  factory PdfStateConroller() => instance;

  final _controller = StreamController<PdfState>.broadcast();
  Stream<PdfState> get stream => _controller.stream;

  PdfState _state = .empty();
  PdfState get state => _state;
  final sortList = [
    ...TSort.getDefaultList,
    TSort(id: 1, title: 'Size', ascTitle: 'Smallest', descTitle: 'Biggest'),
  ];

  Future<void> fetchList() async {
    try {
      _state = _state.copyWith(isLoading: true, error: '', list: []);
      _controller.add(_state);

      final list = await PdfScanner.getAll();

      _state = _state.copyWith(
        isLoading: false,
        error: '',
        list: list,
        isAsc: CFLite.getInstance().getBool('pdf_sort_asc', def: true),
        sortId: CFLite.getInstance().getInt(
          'pdf_sort_id',
          def: TSort.getDateId,
        ),
      );
      _controller.add(_state);
      sort();
    } catch (e) {
      debugPrint('[PdfStateConroller:fetchList]: $e');
      _state = _state.copyWith(isLoading: false, error: e.toString());
      _controller.add(_state);
    }
  }

  void setSort(int sortId, bool isAsc) {
    _state = _state.copyWith(isAsc: isAsc, sortId: sortId);
    CFLite.getInstance().put<bool>('pdf_sort_asc', isAsc);
    CFLite.getInstance().put<int>('pdf_sort_id', sortId);
    //  isAsc: CFLite.getInstance().getBool('pdf_sort_asc', def: true),
    // sortId: CFLite.getInstance().getInt('pdf_sort_id', def: TSort.getDateId),
    sort();
  }

  void sort() {
    final list = _state.list;
    if (_state.sortId == TSort.getDateId) {
      list.sortDate(isNewest: state.isAsc);
    }
    if (_state.sortId == TSort.getTitleId) {
      list.sortA2Z(isA2Z: state.isAsc);
    }
    if (_state.sortId == 1) {
      list.sortSize(isSmallest: state.isAsc);
    }
    _state = _state.copyWith(list: list);
    _controller.add(_state);
  }

  void dispatch(PdfStateEvent event) {
    if (event is PdfDelete) {
      _handleDeletePdf(event);
    }
  }

  void _handleDeletePdf(PdfDelete event) {
    final list = state.list;
    final index = list.indexWhere((e) => e.path == event.path);
    if (index == -1) return;
    // ui
    list.removeAt(index);
    _state = _state.copyWith(list: list);
    _controller.add(_state);
    //disk
    final file = File(event.path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
