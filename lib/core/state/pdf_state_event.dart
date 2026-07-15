import 'package:than_reader/core/models/app_file.dart';

abstract class PdfStateEvent {}

class PdfLoading extends PdfStateEvent {}

class PdfError extends PdfStateEvent {
  final String error;
  PdfError(this.error);
}

class PdfLoaded extends PdfStateEvent {}

class PdfDelete extends PdfStateEvent {
  final AppFile pdf;
  PdfDelete(this.pdf);
}
