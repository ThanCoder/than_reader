import 'dart:convert';
import 'dart:io';

import 'dev_page.dart';

class DevPageApi {
  static const String _url =
      'https://raw.githubusercontent.com/ThanCoder/server_repo/refs/heads/main/dev_page_api.json';
  static Future<List<DevPage>> getList() async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(_url).replace(
        queryParameters: {
          'v': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      final req = await client.getUrl(uri);
      final res = await req.close();

      if (res.statusCode != HttpStatus.ok) {
        return [];
      }

      final body = await res.transform(utf8.decoder).join();

      final json = jsonDecode(body);

      if (json is! List) {
        return [];
      }

      return json
          .whereType<Map<String, dynamic>>()
          .map(DevPage.fromMap)
          .toList();
    } finally {
      client.close();
    }
  }
}
