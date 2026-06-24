import 'dart:async';

import 'package:flutter/material.dart';
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

  Future<void> fetchList() async {
    try {
      _state = _state.copyWith(isLoading: true, error: '', list: []);
      _controller.add(_state);

      final list = await PdfScanner.getAll();
      _state = _state.copyWith(isLoading: false, error: '', list: list);
      _controller.add(_state);
    } catch (e) {
      debugPrint('[PdfStateConroller:fetchList]: $e');
      _state = _state.copyWith(isLoading: false, error: e.toString());
      _controller.add(_state);
    }
  }

  void dispatch(PdfStateEvent event) {}
}
