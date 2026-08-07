import 'dart:io';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

class EpubUtils {
  static List<String> splitHtmlBlocks(String html) {
    final document = html_parser.parseFragment(html);

    final blocks = <String>[];

    for (final node in document.nodes) {
      if (node is Element) {
        blocks.add(node.outerHtml);
      }
    }

    return blocks;
  }

  Future<void> loadFontFromFile(String path, {required String family}) async {
    final bytes = await File(path).readAsBytes();

    final loader = FontLoader(family);
    loader.addFont(
      Future.value(ByteData.sublistView(Uint8List.fromList(bytes))),
    );

    await loader.load();
  }
}
