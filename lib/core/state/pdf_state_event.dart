abstract class PdfStateEvent {}

class PdfLoading extends PdfStateEvent {}

class PdfError extends PdfStateEvent {
  final String error;
  PdfError(this.error);
}

class PdfLoaded extends PdfStateEvent {}

class PdfDelete extends PdfStateEvent {
  final String path;
  PdfDelete(this.path);
}
