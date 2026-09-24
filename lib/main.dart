import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/apps/pdf/pdf_reader.dart';
import 'package:than_reader/apps/pdf/config_widget/pdf_reader_prefer_theme_mode_chooser.dart';
import 'package:than_reader/core/controller/fav_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/reader_track/reader_history_controller.dart';
import 'package:than_reader/platforms/platform_app.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtil.instance.init();

  // recent
  await CFBStore.instance.open(AppUtil.instance.getConfigPath('app.cf.json'));

  await ReaderInfoStore.instance.init(
    AppUtil.instance.getPlatfromExternalConfigPath('reader-file-info-store.du'),
  );

  ControllerManager.register(AllFileController());
  ControllerManager.register(FavController());
  ControllerManager.register(ReaderHistoryController());

  await ControllerManager.initAll();
  // reader
  await PdfReader.cf.open(
    AppUtil.instance.getConfigPath('pdf.reader.config.cfb'),
  );
  PdfReaderPreferThemeModeChooser.init();

  // ModuleApps.instance.registerModule(AppFileReadManager());
  // ModuleApps.instance.registerModule(EpubApp());
  // ModuleApps.instance.registerModule(PdfApp());

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/images/app_icon.png',
  );

  runApp(const PlatformApp());
}
