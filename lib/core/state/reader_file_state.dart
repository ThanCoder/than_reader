import 'package:than_reader/core/models/reader_file.dart';

class ReaderFileState {
  final List<ReaderFile> list;
  final bool isLoading;
  final String error;
  const ReaderFileState({
    required this.list,
    required this.isLoading,
    required this.error,
  });

  factory ReaderFileState.empty() {
    return ReaderFileState(list: [], isLoading: false, error: '');
  }

  ReaderFileState copyWith({
    List<ReaderFile>? list,
    bool? isLoading,
    String? error,
  }) {
    return ReaderFileState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
