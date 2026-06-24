import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_screen.dart';





class PdfrxApp extends ModuleApp<PdfParams, PdfResult> {
  @override
  Future<PdfResult?> go(BuildContext context, PdfParams params) async {
    await context.push(
      builder: (context) =>
          PdfrxScreen(path: params.path, password: params.password),
    );
    return null;
  }
}
