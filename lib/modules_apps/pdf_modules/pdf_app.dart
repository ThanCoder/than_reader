import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/config_storage_factory.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_screen.dart';
import 'package:than_reader/modules_apps/pdf_modules/than_pdf_reader/than_pdf_reader_screen.dart';

class PdfApp extends ModuleApp<PdfParams, PdfResult> {
  @override
  Future<PdfResult?> go(BuildContext context, PdfParams params) async {
    final configPath = params.configPath;

    final config = PdfConfig.fromPathSync(ConfigStorageFactory.create(configPath));
    PdfConfig? changedConfig;
    if (config.readerType == .autoReader) {
      final pdfFile = File(params.path);
      if (pdfFile.size > ((1024 * 1024) * 10)) {
        // big pdf
        changedConfig = await context.push<PdfConfig>(
          builder: (context) => ThanPdfReaderScreen(
            path: params.path,
            password: params.password,
            config: config,
          ),
        );
      } else {
        //small pdf
        changedConfig = await context.push<PdfConfig>(
          builder: (context) => PdfrxScreen(
            path: params.path,
            password: params.password,
            config: config,
          ),
        );
      }
      if (changedConfig != null) {
        changedConfig.savePathSync(ConfigStorageFactory.create(configPath));
      }
    } else if (config.readerType == .pdfrxReader) {
      changedConfig = await context.push<PdfConfig>(
        builder: (context) => PdfrxScreen(
          path: params.path,
          password: params.password,
          config: config,
        ),
      );
    } else if (config.readerType == .thanPdfReader) {
      changedConfig = await context.push<PdfConfig>(
        builder: (context) => ThanPdfReaderScreen(
          path: params.path,
          password: params.password,
          config: config,
        ),
      );
    }

    return null;
  }
}
