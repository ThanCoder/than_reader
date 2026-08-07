import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/utils/utils.dart';
import 'package:than_reader/modules_apps/module_apps.dart';
import 'package:than_reader/modules_apps/reader/app_file_read_manager.dart';

Future<void> goReaderModuleApp(BuildContext context, AppFile file) async {
  await ModuleApps.instance
      .go<AppFileReadManagerParams, AppFileReadManagerResponse>(
        context,
        appId: 'app.file.read.manager',
        params: .new(file, Utils.instance.getCachePath(file.configId)),
      );
}
