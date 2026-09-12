import 'dart:convert';
import 'dart:io';

import 'package:t_server/t_server.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/managers/cache_manager.dart';

class ShareController {
  static final ShareController instance = ShareController._();
  ShareController._();
  factory ShareController() => instance;

  final server = TServer();
  final _router = THttpRouter();
  AllFileController get _allCon => ControllerManager.read<AllFileController>();
  int port = 4445;

  Future<void> init() async {
    _router.clearRoutes();
    _router.get('/', (ctx) async {
      await ctx.response.json({
        'message': 'Than Reader Api Server',
        '/api': 'book file list',
        '/api/thumbnail/:id': 'cover data',
        '/api/book/:id': 'book data && download data',
      });
    });
    _router.get('/api', (ctx) async {
      final json = _allCon.list.map((e) => e.toMap()).toList();
      final jsonString = JsonEncoder.withIndent(' ').convert(json);
      await ctx.response.jsonString(jsonString);
    });
    _router.get('/api/thumbnail/:id', (ctx) async {
      final id = ctx.params['id'];
      if (id == null) {
        await ctx.response.json({'message': 'id not found!', 'success': false});
        return;
      }
      final book = _allCon.getById(id);
      if (book == null) {
        await ctx.response.json({
          'message': 'book not found!',
          'success': false,
        });
        return;
      }
      final coverFile = File(CacheManager.getBookThumbnailCachePath(book));

      await ctx.response.download(coverFile);
    });

    _router.get('/api/book/:id', (ctx) async {
      final id = ctx.params['id'];
      if (id == null) {
        await ctx.response.json({'message': 'id not found!', 'success': false});
        return;
      }
      final book = _allCon.getById(id);
      if (book == null) {
        await ctx.response.json({
          'message': 'book not found!',
          'success': false,
        });
        return;
      }
      final bookFile = File(book.path);

      await ctx.response.download(bookFile);
    });
    server.setRouter(_router);
  }

  Future<void> start() async {
    await server.start(address: '0.0.0.0', port: port);
  }
}
