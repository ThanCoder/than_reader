import 'package:than_reader/core/models/reader_file.dart';

abstract class IReaderConfig {
  int get page;
  bool get isAdult;
  bool get isCompleted;
  ReaderFileType get type;
}
