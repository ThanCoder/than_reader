import 'package:cfb_store/cfb_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/platforms/platform_app.dart';
import 'package:than_reader/core/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppUtils.instance.init();

  // recent
  await CFBStore.instance.open(AppUtils.instance.getConfigPath('app.cf.json'));

  await CFBStore.getInstance.open(
    AppUtils.instance.getConfigPath('app.config.cfb'),
  );

  ControllerManager.register(AllFileController());
  await ControllerManager.initAll();

  // ModuleApps.instance.registerModule(AppFileReadManager());
  // ModuleApps.instance.registerModule(EpubApp());
  // ModuleApps.instance.registerModule(PdfApp());

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/images/app_icon.png',
  );

  runApp(const PlatformApp());
}
