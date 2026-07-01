import 'dart:async';
import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_fav_state.dart';
import 'package:than_reader/core/utils/utils.dart';

class PdfFavController {
  static PdfFavController instance = PdfFavController._();
  PdfFavController._();
  factory PdfFavController() => instance;

  PdfFavState _state = .empty();
  PdfFavState get state => _state;
  Stream<PdfFavState> get stateStream => _controller.stream;

  final _controller = StreamController<PdfFavState>.broadcast();
  final _store = CFBStore();

  Future<void> init() async {
    await _store.open(Utils().getConfigPath('pdf-fav.store.cbf'));
  }

  Future<void> getAll() async {
    _state = _state.copyWith(isLoading: true, error: '');
    _controller.add(_state);

    final list = List<String>.from(_store.getList('fav-list'));
    final existsList = <PdfFile>[];
    for (var path in list) {
      final file = File(path);
      if (!file.existsSync()) continue;
      existsList.add(PdfFile.fromFile(file));
    }
    _state = _state.copyWith(favPathList: existsList);
  }

  Future<void> _saveAll() async {
    final pathList = _state.favPathList.map((e) => e.path).toList();
    _store.put('fav-list', pathList);
    await _store.writeAll();
  }

  void add(PdfFile file) {
    _state.favPathList.insert(0, file);
    _controller.add(_state);
    _saveAll();
  }

  void remove(PdfFile file) {
    final index = state.favPathList.indexWhere((e) => e.path == file.path);
    if (index == -1) return;
    _state.favPathList.removeAt(index);
    _controller.add(_state);
    _saveAll();
  }

  bool isExists(PdfFile file) {
    final index = state.favPathList.indexWhere((e) => e.path == file.path);
    return index != -1;
  }
}
