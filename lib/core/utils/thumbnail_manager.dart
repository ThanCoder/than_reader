import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:than_pdf_engine/than_pdf_engine_bindings_generated.dart';

class ThumbnailRequest {
  final String pdfPath;
  final String outPath;
  final int pageIndex;
  final int width;
  final int height;
  final int quality;
  final String? password;
  final SendPort replyPort;

  ThumbnailRequest({
    required this.pdfPath,
    required this.outPath,
    required this.pageIndex,
    required this.width,
    required this.height,
    required this.quality,
    this.password,
    required this.replyPort,
  });
}

class ThumbnailManager {
  static Isolate? _isolate;
  static SendPort? _toWorkerPort;
  static Timer? _shutdownTimer;
  static Future<void>? _intializationFuture;
  // 💡 ပြိုင်တူဝင်လာတဲ့ Call တွေကို Isolate တစ်ခုတည်းဆီပဲ စုပြုံတိုးစေဖို့ Gatekeeper ထားမယ်
  // အလုပ်လာတိုင်း အလိုအလျောက် ပွင့်မယ့် Internal Init
  static Future<void> _ensureInitialized() async {
    // Timer ရှိနေရင် Cancel လုပ်မယ် (အလုပ်အသစ် ရောက်လာလို့)
    _shutdownTimer?.cancel();

    if (_toWorkerPort != null) return; // ပွင့်ပြီးသားဆိုရင် ဘာမှမလုပ်ဘူး

    _intializationFuture ??= _spawnWorker();
    await _intializationFuture;
  }

  static Future<bool> generate(
    String pdfPath,
    String outPath, {
    int pageIndex = 0,
    int width = 200,
    int height = 200,
    int quality = 70,
    String? password,
  }) async {
    // ၁။ အလုပ်မလုပ်ခင် Isolate ရှိမရှိ စစ်၊ မရှိရင် အော်တို ဖွင့်မယ်
    await _ensureInitialized();

    final responsePort = ReceivePort();
    final request = ThumbnailRequest(
      pdfPath: pdfPath,
      outPath: outPath,
      pageIndex: pageIndex,
      width: width,
      height: height,
      quality: quality,
      password: password,
      replyPort: responsePort.sendPort,
    );

    _toWorkerPort!.send(request);

    final result = await responsePort.first as bool;
    responsePort.close();

    // ၂။ အလုပ်တစ်ခုပြီးတိုင်း Auto-Shutdown Timer ကို စမောင်းမယ်
    _startShutdownTimer();

    return result;
  }

  static void _startShutdownTimer() {
    _shutdownTimer?.cancel(); // Timer အဟောင်းရှိရင် ဖျက်

    // အလုပ်မရှိဘဲ ၅ စက္ကန့် ငြိမ်နေရင် Isolate ကို သတ်ပစ်မယ်
    _shutdownTimer = Timer(const Duration(seconds: 5), () {
      if (_toWorkerPort != null) {
        _toWorkerPort!.send("SHUTDOWN"); // Worker ကို ပိတ်ခိုင်း
        _isolate?.kill(priority: Isolate.immediate); // Isolate ကို အပြီးသတ်

        // Variable တွေကို Clear ပြန်လုပ်
        _isolate = null;
        _toWorkerPort = null;
        debugPrint(
          "[ThumbnailManager]: Background Isolate ကို Auto-Off လုပ်လိုက်ပါပြီ။",
        );
      }
    });
  }

  static Future<void> _spawnWorker() async {
    final receive = ReceivePort();
    _isolate = await Isolate.spawn(_thumbnailWorker, receive.sendPort);
    _toWorkerPort = await receive.first as SendPort;
    _intializationFuture = null;
  }
}

Future<void> _thumbnailWorker(SendPort mainSendPort) async {
  final receivePort = ReceivePort();
  mainSendPort.send(receivePort.sendPort);

  pdfium_init();

  final List<ThumbnailRequest> queue = [];
  bool isProcessing = false;

  Future<void> processQueue() async {
    if (isProcessing || queue.isEmpty) return;
    isProcessing = true;

    while (queue.isNotEmpty) {
      final req = queue.removeAt(0);

      final pdfPathPtr = req.pdfPath.toNativeUtf8();
      final outPathPtr = req.outPath.toNativeUtf8();
      Pointer<Utf8> passwordPtr = nullptr;
      if (req.password != null) {
        passwordPtr = req.password!.toNativeUtf8();
      }

      try {
        pdf_util_saveJpgWithIndex(
          pdfPathPtr.cast<Char>(),
          passwordPtr == nullptr ? nullptr : passwordPtr.cast<Char>(),
          outPathPtr.cast<Char>(),
          req.pageIndex,
          req.width,
          req.height,
          req.quality,
        );
        req.replyPort.send(true);
      } catch (e) {
        req.replyPort.send(false);
      } finally {
        calloc.free(pdfPathPtr);
        calloc.free(outPathPtr);
        if (passwordPtr != nullptr) calloc.free(passwordPtr);
      }

      await Future.delayed(Duration.zero);
    }
    isProcessing = false;
  }

  receivePort.listen((message) {
    if (message is ThumbnailRequest) {
      queue.add(message);
      processQueue();
    } else if (message == "SHUTDOWN") {
      // UI ဘက်က ပိတ်ခိုင်းရင် Isolate ကို Close လုပ်မယ်
      receivePort.close();
    }
  });
}
