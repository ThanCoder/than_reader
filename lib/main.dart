import 'package:cf_lite/cf_lite.dart';
import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/main_app/my_app.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_app.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_app.dart';
import 'package:than_reader/modules_apps/pdf_modules/than_pdf_reader/than_pdf_reader_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pdfrxInitialize();

  await Utils.instance.init();

  // recent
  await CFLite.getInstance().init(
    dbPath: Utils.instance.getConfigPath('app.cf.json'),
  );
  await CFBStore.getInstance.open(
    Utils.instance.getConfigPath('app.config.cfb'),
  );
  await PdfFavController.instance.init();
  await PdfFavController.instance.getAll(); //get all fav list

  AppManager.instance.register(PdfApp());
  AppManager.instance.register(PdfrxApp());
  AppManager.instance.register(ThanPdfReaderApp());

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/images/app_icon.png',
  );

  runApp(const MyApp());
}
