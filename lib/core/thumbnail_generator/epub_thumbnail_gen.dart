import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/material.dart';

class EpubThumbnailGen {
  static EpubThumbnailGen instance = EpubThumbnailGen._();
  EpubThumbnailGen._();
  factory EpubThumbnailGen() => instance;

  /// bool -> if generated ? true:false;
  Future<bool> generate(
    String src,
    String outPath, {
    bool isOverride = false,
  }) async {
    final outFile = File(outPath);
    if (!isOverride && outFile.existsSync()) {
      return false;
    }
    await _initIsolate();
    _resetAutoCloseTimer();
    final rPort = ReceivePort();
    bool success = false;
    try {
      _workerSendPort?.send({
        'reply': rPort.sendPort,
        'path': src,
        'outPath': outPath,
      });
      success = await rPort.first as bool;
    } finally {
      // အလုပ်ပြီးသွားချိန်မှ Timer ကို ပြန်စတင်မည်
      _resetAutoCloseTimer();
    }
    rPort.close();
    return success;
  }

  Completer? _initCompleter;

  Future<void> _initIsolate() async {
    // 1. Isolate Ready ဖြစ်ပြီးသားဆိုလျှင် တန်းထွက်မည်
    if (_workerSendPort != null) return;

    // 2. တခြား call တစ်ခုက စတင် initialization လုပ်နေပြီဆိုပါက ထို Future ထဲတွင် စောင့်မည်
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    // 3. ပထမဆုံး Call ဝင်လာပါက Completer ကို စတင်မည်
    _initCompleter = Completer<void>();

    try {
      await _startIsolate();

      _initCompleter!.complete();
    } catch (e) {
      debugPrint('[EpubThumbnailGen:_initIsolate]: $e');
      _initCompleter!.completeError(e);
      _initCompleter = null;
      rethrow;
    } finally {
      // Initialization ပြီးပါက Completer ကို cleared လုပ်ပေးမည်
      if (_workerSendPort != null) {
        _initCompleter = null;
      }
    }
    return _initCompleter?.future;
  }

  Isolate? _isolate;
  SendPort? _workerSendPort;
  Timer? _autoTimer;
  Duration autoCloseTimer = Duration(seconds: 5);

  Future<void> _startIsolate() async {
    final rPort = ReceivePort();
    _isolate = await Isolate.spawn(_genEpubThumbnailWorker, rPort.sendPort);
    _workerSendPort = await rPort.first as SendPort;
    rPort.close();
    debugPrint('[EpubThumbnailGen]: Isolate Started');
  }

  void _resetAutoCloseTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer(autoCloseTimer, dispose);
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _workerSendPort = null;
    _initCompleter = null;
    _autoTimer?.cancel();
    _autoTimer = null;
    debugPrint('[EpubThumbnailGen]: Isolate disposed due to inactivity.');
  }
}

void _genEpubThumbnailWorker(SendPort mainSendPort) {
  final rPort = ReceivePort();
  mainSendPort.send(rPort.sendPort);

  bool gen(String path, String outPath) {
    final ep = EpubEngine();
    ep.open(path);
    final res = ep.writeAsCoverFile(outPath);
    ep.dispose();
    return res;
  }

  rPort.listen((message) {
    if (message is Map) {
      final reply = message['reply'] as SendPort;
      final path = message['path'] as String;
      final outPath = message['outPath'] as String;
      final res = gen(path, outPath);

      reply.send(res);
    }
  });
}
