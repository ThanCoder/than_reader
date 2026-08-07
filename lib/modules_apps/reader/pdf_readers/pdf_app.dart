import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/modules_apps/module_apps.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/config_storage_factory.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdf_config.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdfrx/pdfrx_screen.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/than_pdf_reader/than_pdf_reader_screen.dart';

class PdfParams extends IModuleAppParams {
  final ReaderFile file;
  PdfParams(this.file);
}

class PdfResult extends IModuleAppResponse {
  final PdfConfig config;
  PdfResult(this.config);
}

class PdfApp implements IModuleApp<PdfParams, PdfResult> {
  @override
  String get appId => 'pdf.reader.app';

  @override
  Future<PdfResult?> go(BuildContext context, PdfParams params) async {
    final configPath = params.file.configPath;

    final config = PdfConfig.fromPathSync(
      ConfigStorageFactory.create(configPath),
    );
    PdfConfig? changedConfig;
    if (config.readerType == .autoReader) {
      final file = File(params.file.path);
      if (file.size > ((1024 * 1024) * 10)) {
        // big pdf
        changedConfig = await context.push<PdfConfig>(
          builder: (context) => ThanPdfReaderScreen(
            path: params.file.path,
            password: null,
            config: config,
          ),
        );
      } else {
        //small pdf
        changedConfig = await context.push<PdfConfig>(
          builder: (context) => PdfrxScreen(
            path: params.file.path,
            password: null,
            config: config,
          ),
        );
      }
      if (changedConfig != null) {
        changedConfig.savePathSync(ConfigStorageFactory.create(configPath));
      }
    } else if (config.readerType == .pdfrxReader) {
      changedConfig = await context.push<PdfConfig>(
        builder: (context) =>
            PdfrxScreen(path: params.file.path, password: null, config: config),
      );
    } else if (config.readerType == .thanPdfReader) {
      changedConfig = await context.push<PdfConfig>(
        builder: (context) => ThanPdfReaderScreen(
          path: params.file.path,
          password: null,
          config: config,
        ),
      );
    }
    if (changedConfig != null) {
      await changedConfig.savePath(ConfigStorageFactory.create(configPath));
    }

    return null;
  }
}
