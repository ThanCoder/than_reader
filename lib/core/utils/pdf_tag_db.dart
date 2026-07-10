import 'dart:convert';

import 'package:cfb_store/cfb_store.dart';
import 'package:crypto/crypto.dart';

class PdfTagDB {
  static PdfTagDB instance = PdfTagDB._();
  PdfTagDB._();
  factory PdfTagDB() => instance;

  final _db = CFBStore();

  Future<void> open(String dbPath) async {
    await _db.open(dbPath);
  }

  String pathToId(String pdfPath) {
    return sha1.convert(utf8.encode(pdfPath)).toString();
  }

  List<String> getList(String pdfPath) {
    return List<String>.from(_db.getList(pathToId(pdfPath)));
  }

  Future<bool> setList(String pdfPath, List<String> value) async {
    _db.put(pathToId(pdfPath), value);
    return await _db.writeAll();
  }
}
