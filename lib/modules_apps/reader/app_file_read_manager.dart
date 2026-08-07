import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/modules_apps/module_apps.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_app.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdf_app.dart';

class AppFileReadManagerParams extends IModuleAppParams {
  final AppFile file;
  final String cachePath;
  AppFileReadManagerParams(this.file, this.cachePath);
}

class AppFileReadManagerResponse extends IModuleAppResponse {}

class AppFileReadManager
    implements
        IModuleApp<AppFileReadManagerParams, AppFileReadManagerResponse> {
  @override
  String get appId => 'app.file.read.manager';

  @override
  Future<AppFileReadManagerResponse?> go(
    BuildContext context,
    AppFileReadManagerParams params,
  ) async {
    if (params.file.type == .epub) {
      await ModuleApps.instance.go<EpubParams, EpubReponse>(
        context,
        appId: 'epub.reader',
        params: .new(params.file, params.cachePath),
      );
      return null;
    } else if (params.file.type == .pdf) {
      await ModuleApps.instance.go<PdfParams, PdfResult>(
        context,
        appId: 'pdf.reader.app',
        params: .new(params.file),
      );
      return null;
    } else {
      throw UnsupportedError(
        'UnSupported Reader: Type -> `${params.file.type.name}`',
      );
    }
  }
}
