import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/core/utils/reader_file_util.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';

Future<void> goReaderModuleApp(BuildContext context, ReaderFile file) async {
  final configRes = await ReaderFileUtil.getPdfConfig(file);
  if (!context.mounted) return;

  if (configRes.isErr) {
    showErrorDialog(context, configRes.unwrapError());
    return;
  }

  final newCof = await context.pushMaterialPageRoute<PdfConfig>(
    builder: (mainCtx) => PdfReader(file: file, config: configRes.unwrap()),
  );
  if (newCof != null) {
    // if (!context.mounted) return;
    await ReaderFileUtil.savePdfConfig(newCof, file);
  }
  // await ModuleApps.instance
  //     .go<AppFileReadManagerParams, AppFileReadManagerResponse>(
  //       context,
  //       appId: 'app.file.read.manager',
  //       params: .new(file, AppUtils.instance.getCachePath(file.configId)),
  //     );
  // ReaderFileRecentController.instance.addList(file.path);
}
