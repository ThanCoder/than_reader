import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

import 'package:dart_core_extensions/dart_core_extensions.dart';

class PdfConfigIdGenerator {
  static String generateSync(String pdfPath) {
    final file = File(pdfPath);
    // file မရှိရင် name ပေးထားမယ်
    if (!file.existsSync()) {
      return sha1.convert(utf8.encode(pdfPath.getName())).toString();
    }
    final size = file.size;
    final chunkSize = 1024 * 2; //2kb size
    final List<int> combinedBuff = [];
    // file size က 6kb ထက်ကို ငယ်ရင် file အကုန် read လိုက်မယ်
    if (size <= chunkSize * 3) {
      combinedBuff.addAll(file.readAsBytesSync());
    }
    // 6kb ထက်ကြီးနေရင်
    else {
      final raf = file.openSync(mode: .read);
      try {
        // start
        combinedBuff.addAll(raf.readSync(chunkSize));
        // middle
        final middlePos = size ~/ 2;
        raf.setPositionSync(middlePos);
        combinedBuff.addAll(raf.readSync(chunkSize));
        // end
        raf.setPositionSync(size - chunkSize);
        combinedBuff.addAll(raf.readSync(chunkSize));
      } finally {
        raf.closeSync();
      }
    }

    final contentHash = sha1.convert(combinedBuff).toString();
    final uinqueString = '${contentHash}_$size';
    return sha1.convert(utf8.encode(uinqueString)).toString();
  }
}
