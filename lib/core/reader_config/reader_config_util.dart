import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:than_reader/core/reader_config/pdf_config.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/core/utils/result.dart';

class ReaderConfigUtil {
  static final ReaderConfigUtil instance = ReaderConfigUtil._();
  ReaderConfigUtil._();
  factory ReaderConfigUtil() => instance;

  final _eventCon = StreamController<String>.broadcast();

  /// listen changed config id
  Stream<String> get events => _eventCon.stream;

  Result<String, String> getConfigPathFromId(String readerConfigId) {
    final cfName = '$readerConfigId-config.cbf';
    if (Platform.isAndroid) {
      return Ok(AppUtil.instance.getAndroidExternalConfigPath(cfName));
    }
    if (Platform.isLinux) {
      return Ok(AppUtil.instance.getConfigPath(cfName));
    }
    return Err('Platform only -> `linux,android`');
  }

  Future<Map<String, dynamic>> getConfigMapOr(String readerConfigId) async {
    final res = await getConfigMap(readerConfigId);
    return res.fold(onErr: (err) => {}, onOk: (val) => val);
  }

  Future<Result<Map<String, dynamic>, String>> getConfigMap(
    String readerConfigId,
  ) async {
    final p = getConfigPathFromId(readerConfigId);
    if (p.isErr) {
      return Err(p.unwrapError());
    }
    try {
      final f = File(p.unwrap());
      if (!f.existsSync()) {
        return Ok({});
      }

      final source = await f.readAsString();
      final json = jsonDecode(source);
      return Ok(json);
    } catch (e) {
      return Err(e.toString());
    }
  }

  Result<String, String> getConfigPath(ReaderFile file) {
    return getConfigPathFromId(file.configId);
  }

  Future<Result<bool, String>> savePdfConfig(
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
      // event
      _eventCon.add(file.configId);
      return Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  Future<PdfConfig?> getPdfConfigOrNull(ReaderFile file) async {
    final res = await getPdfConfig(file);
    if (res.isErr) return null;
    return res.unwrap();
  }

  Future<Result<PdfConfig, String>> getPdfConfig(ReaderFile file) async {
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
