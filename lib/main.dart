import 'package:cf_lite/cf_lite.dart';
import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/core/utils/pdf_tag_db.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/main_app/my_app.dart';
import 'package:than_reader/modules_apps/reader/app_file_read_manager.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_app.dart';
import 'package:than_reader/modules_apps/module_apps.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/app_pdf_reader_type_chooser.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/pdf_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  pdfrxFlutterInitialize();

  await Utils.instance.init();

  // recent
  await CFLite.getInstance().init(
    dbPath: Utils.instance.getConfigPath('app.cf.json'),
  );
  await CFBStore.getInstance.open(
    Utils.instance.getConfigPath('app.config.cfb'),
  );
  await PdfTagDB.instance.open(Utils.instance.getConfigPath('pdf.tags.cfb'));
  await PdfFavController.instance.init();
  await PdfFavController.instance.getAll(); //get all fav list
  /// app reader type
  AppAutoReaderTypeChooser.init();

  // app file all controller
  await ReaderFileAllStateConroller.instance.init();

  ModuleApps.instance.registerModule(AppFileReadManager());
  ModuleApps.instance.registerModule(EpubApp());
  ModuleApps.instance.registerModule(PdfApp());

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/images/app_icon.png',
  );

  runApp(const MyApp());
}
