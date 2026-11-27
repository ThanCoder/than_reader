import 'dart:convert';
import 'dart:io';

import 'package:t_server/t_server.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/managers/cache_manager.dart';
import 'package:than_reader/core/reader_config/reader_config_util.dart';
import 'package:than_reader/core/utils/platform_util.dart';
import 'package:than_reader/platforms/pages/novel/novel_controller.dart';

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
        '/api/books': 'book file list',
        '/api/book-config/:id': 'book file config',
        '/api/thumbnail/:id': 'cover data',
        '/api/book/:id': 'book data && download data',
        '/api/novels': 'novel list',
        '/api/download/?path=[]': 'download file path',
      });
    });
    _router.get('/api/download', (ctx) async {
      final path = ctx.query['path'];
      if (path == null) {
        await ctx.response.text('`?path=[]` Not Found!');
        return;
      }
      final f = File(path);
      await ctx.response.download(f);
    });
    // book files
    _router.get('/api', (ctx) async {
      final json = _allCon.list.map((e) => e.toMap()).toList();
      final jsonString = JsonEncoder.withIndent(' ').convert(json);
      await ctx.response.jsonString(jsonString);
    });
    _router.get('/api/books', (ctx) async {
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
      if (!coverFile.existsSync()) {
        await PlatformUtil.genThumbnail(
          book.path,
          outPath: coverFile.path,
          type: book.type,
        );
      }

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
    _router.get('/api/book-config/:id', (ctx) async {
      final id = ctx.params['id'];
      if (id == null) {
        await ctx.response.text('`/api/book-config/[:id]` Not Found!');
        return;
      }
      final map = await ReaderConfigUtil.instance.getConfigMapOr(id);
      final jsonString = JsonEncoder.withIndent(' ').convert(map);
      await ctx.response.jsonString(jsonString);
    });
    // novel
    _router.get('/api/novels', (ctx) async {
      final con = NovelController.instance;
      if (con.list.isEmpty) {
        await con.fetchList();
      }
      final json = con.list.map((e) => e.toJson()).toList();
      final jsonString = JsonEncoder.withIndent(' ').convert(json);
      await ctx.response.jsonString(jsonString);
    });
    // _router.get('/api/novels', (ctx) async {
    //   final con = NovelController.instance;
    //   if (con.list.isEmpty) {
    //     await con.fetchList();
    //   }
    //   final json = con.list.map((e) => e.toJson()).toList();
    //   final jsonString = JsonEncoder.withIndent(' ').convert(json);
    //   await ctx.response.jsonString(jsonString);
    // });

    // reset
    server.setRouter(_router);
  }

  Future<void> start() async {
    await server.start(address: '0.0.0.0', port: port);
  }
}
