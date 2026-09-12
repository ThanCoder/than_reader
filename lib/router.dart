import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/controller/reader_track/reader_history_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/core/models/reader_history.dart';
import 'package:than_reader/core/utils/reader_file_util.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store_desc_page.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store_form_page.dart';

Future<void> goReaderModuleApp(BuildContext context, ReaderFile file) async {
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
  final box = ReaderInfoStore.instance.infoBox;
  final infoRes = await box.getOne(
    (val) => val.configIds.contains(file.configId),
  );
  if (!context.mounted) return;
  ReaderInfo info = .empty(title: file.name, configIds: [file.configId]);
  String desc = '';
  if (infoRes.isOk) {
    info = infoRes.unwrap();
    final con = await info.getContent<String>();
    if (con.isOk) {
      desc = con.unwrap();
    }
  }
  if (!context.mounted) return;
  final res = await context.pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
    builder: (mainCtx) => ReaderInfoStoreFormPage(info: info, desc: desc),
  );
  if (res == null) return;
  await box.add(res.info, contentWriter: TextCompressContentWriter(res.desc));
}
