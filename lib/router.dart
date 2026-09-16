import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/controller/reader_track/reader_history_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/core/models/reader_history.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/core/utils/reader_file_util.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_desc_page.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_page.dart';

Future<void> goReaderModuleApp(BuildContext context, ReaderFile file) async {
  final infoDialogEnable = AppUtils.instance.config.getBool(
    appReaderInfoDialogKey,
  );
  if (infoDialogEnable) {
    final box = ReaderInfoStore.instance.infoBox;
    final infoRes = await box.getOne(
      (val) => val.configIds.contains(file.configId),
    );
    if (infoRes.isOk) {
      if (!context.mounted) return;
      final conf = await showConfirmDialog(
        context,
        'Want To Read Info',
        confirmText: 'Read Info',
        closeText: 'Read Reader',
      );
      if (conf) {
        if (!context.mounted) return;
        context.pushMaterialPageRoute(
          builder: (mainCtx) => ReaderInfoStoreDescPage(info: infoRes.unwrap()),
        );
        return;
      }
    }
  }

  final configRes = await ReaderFileUtil.getPdfConfig(file);
  if (!context.mounted) return;

  if (configRes.isErr) {
    showErrorDialog(context, configRes.unwrapError());
    return;
  }

  // history
  final stopWatch = Stopwatch();
  stopWatch.start();
  final hisCon = ControllerManager.read<ReaderHistoryController>();
  ReaderHistory his = hisCon.getId(file.configId);

  final newCof = await context.pushMaterialPageRoute<PdfConfig>(
    builder: (mainCtx) => PdfReader(file: file, config: configRes.unwrap()),
  );
  if (newCof != null) {
    // if (!context.mounted) return;
    await ReaderFileUtil.savePdfConfig(newCof, file);
    his = his.copyWith(lastPage: newCof.page, totalPage: newCof.totalPage);
  }
  stopWatch.stop();

  // add history
  hisCon.update(
    his.copyWith(
      lastReadAt: .now(),
      totalReadTime: stopWatch.elapsed,
      readCount: his.readCount + 1,
    ),
  );
  // print('Dev: read time: ${stopWatch.elapsed}');
}

// await ModuleApps.instance
//     .go<AppFileReadManagerParams, AppFileReadManagerResponse>(
//       context,
//       appId: 'app.file.read.manager',
//       params: .new(file, AppUtils.instance.getCachePath(file.configId)),
//     );
// ReaderFileRecentController.instance.addList(file.path);

Future<void> goInfoDescPage(BuildContext context, ReaderFile file) async {
  final box = ReaderInfoStore.instance.infoBox;
  final infoRes = await box.getOne(
    (val) => val.configIds.contains(file.configId),
  );
  if (infoRes.isErr) return;
  if (!context.mounted) return;
  context.pushMaterialPageRoute(
    builder: (mainCtx) => ReaderInfoStoreDescPage(info: infoRes.unwrap()),
  );
}

Future<void> goInfoFormPage(BuildContext context, ReaderFile file) async {
  // if (!context.mounted) return;
  await context.pushMaterialPageRoute(
    builder: (mainCtx) => ReaderInfoStorePage(
      bookTitle: file.name,
      bookConfigIds: [file.configId],
    ),
  );
  // final res = await context.pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
  //   builder: (mainCtx) => ReaderInfoStoreFormPage(info: info, desc: desc),
  // );
  // if (res == null) return;
  // await box.add(res.info, contentWriter: TextCompressContentWriter(res.desc));
}
