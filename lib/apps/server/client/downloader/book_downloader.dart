import 'dart:async';

import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';

class BookDownloader extends TDownloadManagerSimple {
  final ReaderFile book;
  BookDownloader(this.book);

  @override
  void cancel() {}

  @override
  Future<void> startWorking(
    StreamController<TProgress> controller,
    List<String> urls,
  ) async {
    
  }
}
