import 'package:flutter/material.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/main_app/my_app.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdfrx/pdfrx_app.dart';

void main() async {
  await AppUtils.instance.init();

  AppManager.instance.register(PdfrxApp());

  runApp(const MyApp());
}
