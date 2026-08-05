import 'package:flutter/material.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_reader_screen.dart';
import 'package:than_reader/modules_apps/module_apps.dart';

class EpubParams extends IModuleAppParams {
  final AppFile file;
  EpubParams(this.file);
}

class EpubReponse extends IModuleAppResponse {}

class EpubApp implements IModuleApp<EpubParams, EpubReponse> {
  @override
  String get appId => 'epub.reader';

  @override
  Future<EpubReponse?> go(BuildContext context, EpubParams params) async {
    return await Navigator.push<EpubReponse>(
      context,
      MaterialPageRoute(
        builder: (context) => EpubReaderScreen(file: params.file),
      ),
    );
  }
}
