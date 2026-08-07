import 'dart:async';

import 'package:cfb_store/cfb_store.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/partials/sort_provider.dart';

class ReaderFileSortController {
  static ReaderFileSortController instance = ReaderFileSortController._();
  ReaderFileSortController._();
  factory ReaderFileSortController() => instance;

  final _controller = StreamController<SortItem>.broadcast();
  Stream<SortItem> get stream => _controller.stream;
  SortItem currentItem = SortItem.dateSortItem;

  final sortList = [
    SortItem.nameSortItem,
    SortItem.dateSortItem,
    SortItem.sizeSortItem,
  ];
  void init() {
    ///Sort
    SortItem sortItem = SortItem.dateSortItem;
    final id = CFBStore.getInstance.getInt('app_file_sort_id', -1);
    if (id != -1) {
      sortItem = sortList.firstWhere(
        (e) => e.id == id,
        orElse: () => SortItem.dateSortItem,
      );
      sortItem = sortItem.copyWith(
        isTrue: CFBStore.getInstance.getBool('app_file_sort_true'),
      );
    }
    currentItem = sortItem;
    _controller.add(currentItem);
  }

  void setSort(SortItem item) {
    CFBStore.getInstance.put('app_file_sort_id', item.id);
    CFBStore.getInstance.put('app_file_sort_true', item.isTrue);
    CFBStore.getInstance.writeAll();
    currentItem = item;

    _controller.add(currentItem);
  }

  void sort(List<ReaderFile> list) {
    if (currentItem.id == SortItem.dateSortItem.id) {
      list.sortDate(isNewest: currentItem.isTrue);
    }
    if (currentItem.id == SortItem.nameSortItem.id) {
      list.sortA2Z(isA2Z: currentItem.isTrue);
    }
    if (currentItem.id == SortItem.sizeSortItem.id) {
      list.sortSize(isSmallest: currentItem.isTrue);
    }
  }
}
