// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:than_reader/core/models/app_file.dart';

class PdfFavState {
  final List<AppFile> favPathList;
  final bool isLoading;
  final String error;
  const PdfFavState({
    required this.favPathList,
    required this.isLoading,
    required this.error,
  });
  factory PdfFavState.empty() {
    return PdfFavState(favPathList: [], isLoading: false, error: '');
  }

  PdfFavState copyWith({
    List<AppFile>? favPathList,
    bool? isLoading,
    String? error,
  }) {
    return PdfFavState(
      favPathList: favPathList ?? this.favPathList,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
