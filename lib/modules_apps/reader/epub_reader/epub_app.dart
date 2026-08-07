import 'package:flutter/material.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_config.dart';
import 'package:than_reader/modules_apps/reader/epub_reader/epub_reader_screen.dart';
import 'package:than_reader/modules_apps/module_apps.dart';
import 'package:than_reader/modules_apps/reader/pdf_readers/config_storage_factory.dart';

class EpubParams extends IModuleAppParams {
  final ReaderFile file;
  final String cachePath;
  EpubParams(this.file, this.cachePath);
}

class EpubReponse extends IModuleAppResponse {}

class EpubApp implements IModuleApp<EpubParams, EpubReponse> {
  @override
  String get appId => 'epub.reader';

  @override
  Future<EpubReponse?> go(BuildContext context, EpubParams params) async {
    final configPath = params.file.configPath;

    final config = EpubConfig.fromPathSync(
      ConfigStorageFactory.create(configPath),
    );

    final updatedConfig = await Navigator.push<EpubConfig>(
      context,
      MaterialPageRoute(
        builder: (context) => EpubReaderScreen(
          file: params.file,
          config: config,
          cachePath: params.cachePath,
        ),
      ),
    );
    if (updatedConfig != null) {
      await updatedConfig.savePath(ConfigStorageFactory.create(configPath));
    }
    return null;
  }
}
