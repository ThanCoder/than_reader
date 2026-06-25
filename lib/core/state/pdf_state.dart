import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/pdf_file.dart';

class PdfState {
  final List<PdfFile> list;
  final bool isLoading;
  final String error;
  final int sortId;
  final bool isAsc;
  const PdfState({
    required this.list,
    required this.isLoading,
    required this.error,
    required this.sortId,
    required this.isAsc,
  });

  factory PdfState.empty() {
    return PdfState(
      list: [],
      isLoading: false,
      error: '',
      isAsc: true,
      sortId: TSort.getDateId,
    );
  }

  PdfState copyWith({
    List<PdfFile>? list,
    bool? isLoading,
    String? error,
    int? sortId,
    bool? isAsc,
  }) {
    return PdfState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sortId: sortId ?? this.sortId,
      isAsc: isAsc ?? this.isAsc,
    );
  }
}
