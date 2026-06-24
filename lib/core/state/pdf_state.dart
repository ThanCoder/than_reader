// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:than_reader/core/models/pdf_file.dart';

class PdfState {
  final List<PdfFile> list;
  final bool isLoading;
  final String error;
  const PdfState({
    required this.list,
    required this.isLoading,
    required this.error,
  });

  factory PdfState.empty() {
    return PdfState(list: [], isLoading: false, error: '');
  }

  PdfState copyWith({List<PdfFile>? list, bool? isLoading, String? error}) {
    return PdfState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
