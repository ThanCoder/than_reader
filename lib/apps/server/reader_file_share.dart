import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:linux_sys_ffi/linux_sys_ffi.dart';
import 'package:t_server/t_server.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/apps/thumbnail_generator/thumbnail_generator_factory.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';

class ReaderFileShare {
  static ReaderFileShare instance = ReaderFileShare._();
  ReaderFileShare._();
  factory ReaderFileShare() => instance;

  final server = TServer();
  final _router = THttpRouter();

  final valueNotifier = ValueNotifier<int>(0);
  bool routePathAdded = false;

  Future<void> start() async {
    if (server.isOpened) return;
    server.setRouter(_router);
    await server.start(shared: true, address: '0.0.0.0', port: 4445);
    valueNotifier.value = valueNotifier.value + 1;

    _router.clearRoutes();

    _router.get('/', (ctx) async {
      await ctx.response.text('Reader File Sharing Server Api.');
    });

    _router.get('/api', (ctx) async {
      final map = {
        '/api': 'home',
        '/api/books': '[reader book]',
        '/api/book/download/:id': '[download file]',
        '/api/book/cover/:id': '[download cover image]',
        '/api/book/download-path?path=[path]': '[download file]',
      };
      final jsonString = JsonEncoder.withIndent(' ').convert(map);
      await ctx.response.jsonString(jsonString);
    });
    _router.get('/api/books', (ctx) async {
      final files = ReaderFileAllStateConroller.instance.state.list;
      final data = files.map((e) => e.toMap()).toList();
      final map = {'success': true, 'message': 'books', 'data': data};
      final value = JsonEncoder.withIndent(' ').convert(map);

      await ctx.response.jsonString(value);
    });

    _router.get('/api/book/download/:id', (ctx) async {
      final id = ctx.params['id'];
      if (id == null) {
        await ctx.response.json({
          'success': false,
          'message': 'params id not found!',
          'id': id,
        });
        return;
      }
      final files = ReaderFileAllStateConroller.instance.state.list;
      final index = files.indexWhere((e) => e.configId == id);
      if (index == -1) {
        await ctx.response.json({
          'success': false,
          'message': 'id not found!',
          'id': id,
        });
        return;
      }
      final file = files[index];
      await ctx.response.download(File(file.path));
    });
    // cover
    _router.get('/api/book/cover/:id', (ctx) async {
      final id = ctx.params['id'];
      if (id == null) {
        await ctx.response.json({
          'success': false,
          'message': 'params id not found!',
          'id': id,
        });
        return;
      }
      final files = ReaderFileAllStateConroller.instance.state.list;
      final index = files.indexWhere((e) => e.configId == id);
      if (index == -1) {
        await ctx.response.json({
          'success': false,
          'message': 'id not found!',
          'id': id,
        });
        return;
      }
      final file = files[index];
      final coverFile = File(file.cacheCoverPath);
      //cover မရှိရင် gen ထုတ်ခိုင်းမယ်
      if (!coverFile.existsSync()) {
        await ThumbnailGeneratorFactory.create(
          file,
        ).generate(file.path, coverFile.path);
      }
      await ctx.response.download(coverFile);
    });

    _router.get('/api/book/download-path', (ctx) async {
      final path = ctx.query['path'];
      if (path == null) {
        await ctx.response.json({
          'success': false,
          'message': 'params id not found!',
          'path': path,
        });
        return;
      }
      final files = ReaderFileAllStateConroller.instance.state.list;
      final index = files.indexWhere((e) => e.path == path);
      if (index == -1) {
        await ctx.response.json({
          'success': false,
          'message': 'path not found!',
          'path': path,
        });
        return;
      }
      final file = files[index];
      await ctx.response.download(File(file.path));
    });
  }

  Future<void> restart() async {
    if (server.isOpened) {
      await stop();
    }
    await start();
  }

  Future<void> stop() async {
    if (!server.isOpened) return;
    await server.stop();
    valueNotifier.value = valueNotifier.value + 1;
  }

  Future<List<String>> get allWifiList async {
    if (Platform.isLinux) {
      final wifi = LinuxSysFfi.instance.wifi;
      final infoBuf = StringBuffer();

      final lcIps = await wifi.getAllActiveLocalIps();
      for (var lc in lcIps) {
        infoBuf.writeln(lc.toString());
      }

      final allN = await wifi.getAllNetworkIps();
      for (var net in allN) {
        infoBuf.writeln(net.toString());
      }

      final nmList = wifi.scanWifi();
      for (var nm in nmList) {
        infoBuf.writeln(nm.toString());
      }

      final ipv4Regex = RegExp(r'\b\d{1,3}(?:\.\d{1,3}){3}\b');

      return ipv4Regex
          .allMatches(infoBuf.toString())
          .map((e) => e.group(0)!)
          .toList();
    } else if (Platform.isAndroid) {
      final res = await ThanPkgAndroid.getInstance.wifiHandler.getWifiDetails();
      if (res != null) {
        return res.ipdAddressList;
      }
    }

    return [];
  }
}
