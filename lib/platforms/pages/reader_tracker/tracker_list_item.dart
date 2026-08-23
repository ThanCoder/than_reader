// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';

import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/models/reader_history.dart';

class TrackerListItem {
  final String bookName;
  final String totalReadTimeLabel;
  final String lastReadAtTimeLabel;
  final double progress;
  final int lastPage;
  final int totalPage;
  final ReaderFile book;
  const TrackerListItem({
    required this.bookName,
    required this.totalReadTimeLabel,
    required this.lastReadAtTimeLabel,
    required this.progress,
    required this.lastPage,
    required this.totalPage,
    required this.book,
  });

  factory TrackerListItem.fromHistory(ReaderHistory history, ReaderFile book) {
    final progress = history.lastPage / history.totalPage;
    return .new(
      book: book,
      bookName: book.name,
      totalReadTimeLabel: history.totalReadTime.formatTimeLable(),
      lastReadAtTimeLabel: history.lastReadAt.formatTimeAgo(),
      progress: progress,
      lastPage: history.lastPage,
      totalPage: history.totalPage,
    );
  }
}
