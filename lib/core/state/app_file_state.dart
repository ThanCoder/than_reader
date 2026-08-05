import 'package:than_reader/core/models/app_file.dart';

class AppFileState {
  final List<AppFile> list;
  final bool isLoading;
  final String error;
  const AppFileState({
    required this.list,
    required this.isLoading,
    required this.error,
  });

  factory AppFileState.empty() {
    return AppFileState(list: [], isLoading: false, error: '');
  }

  AppFileState copyWith({List<AppFile>? list, bool? isLoading, String? error}) {
    return AppFileState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
