// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dart_core_extensions/dart_core_extensions.dart';

class ReaderHistory {
  final String fileId;

  /// စုစုပေါင်း ဖတ်ထားတဲ့အချိန်
  final Duration totalReadTime;

  /// နောက်ဆုံးရောက်ခဲ့တဲ့ page
  final int lastPage;

  final int totalPage;

  /// နောက်ဆုံးဖတ်ခဲ့တဲ့အချိန်
  final DateTime lastReadAt;

  /// စဖတ်ခဲ့တဲ့အကြိမ်ရေ
  final int readCount;

  const ReaderHistory({
    required this.fileId,
    required this.totalReadTime,
    required this.lastPage,
    required this.lastReadAt,
    required this.readCount,
    required this.totalPage,
  });

  double getProgress(int totalPages) =>
      totalPages == 0 ? 0 : lastPage / totalPages;

  factory ReaderHistory.empty(String fileId) {
    return .new(
      fileId: fileId,
      totalReadTime: .zero,
      lastPage: 0,
      lastReadAt: .now(),
      readCount: 0,
      totalPage: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileId': fileId,
      'totalReadTime': totalReadTime.inSeconds,
      'lastPage': lastPage,
      'lastReadAt': lastReadAt.millisecondsSinceEpoch,
      'readCount': readCount,
      'totalPage': totalPage,
    };
  }

  factory ReaderHistory.fromMap(Map<String, dynamic> map) {
    return ReaderHistory(
      fileId: map['fileId'] as String,
      totalReadTime: Duration(seconds: map['totalReadTime'] ?? 0),
      lastPage: map['lastPage'] as int,
      lastReadAt: DateTime.fromMillisecondsSinceEpoch(map['lastReadAt'] as int),
      readCount: map['readCount'] as int,
      totalPage: map.getInt(['totalPage']),
    );
  }

  ReaderHistory copyWith({
    String? fileId,
    Duration? totalReadTime,
    int? lastPage,
    int? totalPage,
    DateTime? lastReadAt,
    int? readCount,
  }) {
    return ReaderHistory(
      fileId: fileId ?? this.fileId,
      totalReadTime: totalReadTime ?? this.totalReadTime,
      lastPage: lastPage ?? this.lastPage,
      totalPage: totalPage ?? this.totalPage,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      readCount: readCount ?? this.readCount,
    );
  }

  @override
  String toString() {
    return 'ReaderHistory(fileId: $fileId, totalReadTime: $totalReadTime, lastPage: $lastPage, totalPage: $totalPage, lastReadAt: $lastReadAt, readCount: $readCount)';
  }
}
