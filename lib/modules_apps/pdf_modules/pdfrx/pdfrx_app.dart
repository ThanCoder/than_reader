import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_screen.dart';

class PdfrxApp extends ModuleApp<PdfParams, PdfResult> {
  @override
  Future<PdfResult?> go(BuildContext context, PdfParams params) async {
    final configPath = AppUtils.instance.getConfigPath(
      '${params.path.getName(withExt: false)}-config.json',
    );

    final config = PdfConfig.fromPath(configPath);

    if (!context.mounted) return null;

    final changedConfig = await context.push<PdfConfig>(
      builder: (context) => PdfrxScreen(
        path: params.path,
        password: params.password,
        config: config,
      ),
    );
    if (changedConfig != null) {
      await changedConfig.savePath(configPath);
    }

    return null;
  }
}
