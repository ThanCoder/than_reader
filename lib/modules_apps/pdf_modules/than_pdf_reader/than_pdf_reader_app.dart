import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/config_storage_factory.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_config.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/modules_apps/pdf_modules/than_pdf_reader/than_pdf_reader_screen.dart';

class ThanPdfReaderApp extends ModuleApp<PdfParams, PdfResult> {
  @override
  Future<PdfResult?> go(BuildContext context, PdfParams params) async {
    final configPath = Utils.instance.getConfigPath(
      '${params.path.getName(withExt: false)}-config.json',
    );

    final config = PdfConfig.fromPathSync(
      ConfigStorageFactory.create(configPath),
    );

    if (!context.mounted) return null;

    final changedConfig = await context.push<PdfConfig>(
      builder: (context) => ThanPdfReaderScreen(
        path: params.path,
        password: params.password,
        config: config,
      ),
    );
    if (changedConfig != null) {
      changedConfig.savePathSync(ConfigStorageFactory.create(configPath));
    }

    return null;
  }
}
