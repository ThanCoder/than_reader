import 'package:dual_store/dual_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_form_page.dart';

Future<void> editReaderFileFormPage(
  BuildContext context, {
  required ReaderInfo info,
  String? bookConfigIds,
}) async {
  String desc = '';
  final descRes = await info.getContent<String>();
  if (descRes.isOk) {
    desc = descRes.unwrap();
  }
  if (!context.mounted) return;
  final res = await context.pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
    builder: (mainCtx) => ReaderInfoStoreFormPage(
      info: info,
      desc: desc,
      newConfigId: bookConfigIds,
    ),
  );
  if (res == null) return;
  final infoBox = ReaderInfoStore.instance.infoBox;
  await infoBox.updateById(
    info.generatedId,
    value: res.info,
    contentWriter: TextCompressContentWriter(res.desc),
  );
}
