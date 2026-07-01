// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/partials/sort_provider.dart';

class PdfState {
  final List<PdfFile> list;
  final bool isLoading;
  final String error;
  final SortItem sortItem;
  const PdfState({
    required this.list,
    required this.isLoading,
    required this.error,
    required this.sortItem,
  });

  factory PdfState.empty() {
    return PdfState(
      list: [],
      isLoading: false,
      error: '',
      sortItem: SortItem.dateSortItem,
    );
  }

  PdfState copyWith({
    List<PdfFile>? list,
    bool? isLoading,
    String? error,
    SortItem? sortItem,
  }) {
    return PdfState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sortItem: sortItem ?? this.sortItem,
    );
  }
}
