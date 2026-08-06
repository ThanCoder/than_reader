import 'dart:isolate';

import 'package:epub_engine/epub_engine.dart';
import 'package:flutter/cupertino.dart';

class EpubEngineWorker {
  static EpubEngineWorker instance = EpubEngineWorker._();
  EpubEngineWorker._();
  factory EpubEngineWorker() => instance;
  Isolate? _isolate;
  SendPort? _workerSendport;

  Future<List<String>> open(String path) async {
    final rp = ReceivePort();
    _isolate = await Isolate.spawn<(SendPort, String)>(_epubWorker, (
      rp.sendPort,
      path,
    ));
    final res = await rp.first as (SendPort, List<String>);
    rp.close();
    _workerSendport = res.$1;
    return res.$2;
  }

  Future<String?> getContent(String href) async {
    final rp = ReceivePort();
    _workerSendport?.send({'reply': rp.sendPort, 'href': href});
    final res = await rp.first;
    rp.close();
    return res;
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _workerSendport = null;
  }
}

void _epubWorker((SendPort, String) args) {
  final (mainSendPort, path) = args;
  final rp = ReceivePort();

  final en = EpubEngine();
  en.open(path);
  final list = en.getChapters();
  final hrefList = list.map((e) => e.href).toList();

  mainSendPort.send((rp.sendPort, hrefList));

  rp.listen((message) {
    if (message is Map) {
      try {
        final reply = message['reply'] as SendPort;
        final href = message['href'] as String;

        final res = en.getChapterContent(.new(id: 'id', href: href));
        reply.send(res);
      } catch (e) {
        debugPrint('[EpubEngineWorker:_epubWorker]: $e');
      }
    }
  });
}
