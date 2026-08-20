import 'dart:convert';
import 'dart:io';

import 'package:than_reader/apps/pdf/pdf_config.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/core/utils/result.dart';

class ReaderFileUtil {
  static Result<String, String> getConfigPath(ReaderFile file) {
    final cfName = '${file.configId}-config.cbf';
    if (Platform.isAndroid) {
      return Ok(AppUtils.instance.getAndroidExternalConfigPath(cfName));
    }
    if (Platform.isLinux) {
      return Ok(AppUtils.instance.getCachePath(cfName));
    }
    return Err('Platform only -> `linux,android`');
  }

  static Future<Result<bool, String>> savePdfConfig(
    PdfConfig config,
    ReaderFile file,
  ) async {
    try {
      final pathRes = getConfigPath(file);
      if (pathRes.isErr) {
        return Err(pathRes.unwrapError());
      }

      final map = config.toMap();
      final f = File(pathRes.unwrap());
      await f.writeAsString(jsonEncode(map));
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  static Future<Result<PdfConfig, String>> getPdfConfig(ReaderFile file) async {
    final pathRes = getConfigPath(file);
    if (pathRes.isErr) {
      return Err(pathRes.unwrapError());
    }
    try {
      final f = File(pathRes.unwrap());
      if (f.existsSync()) {
        final con = await f.readAsString();
        final map = jsonDecode(con);
        return Ok(PdfConfig.fromMap(map));
      }
    } catch (e) {
      Err(e.toString());
    }
    return Ok(.empty());
  }
}
