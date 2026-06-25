import 'package:cf_lite/cf_lite.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/main_app/my_app.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_app.dart';

void main() async {
  await AppUtils.instance.init();

  // recent
  await CFLite.getInstance().init(
    dbPath: AppUtils.instance.getAppConfigPath('app.cf.json'),
  );

  AppManager.instance.register(PdfrxApp());

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/images/app_icon.png',
  );

  runApp(const MyApp());
}
