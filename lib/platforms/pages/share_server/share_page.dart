import 'dart:io';

import 'package:flutter/material.dart';
import 'package:than_pkg_android/than_pkg_android.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/pages/share_server/share_controller.dart';

class SharePage extends StatefulWidget {
  const new({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  void initState() {
    init();
    super.initState();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(true);
    }
  }

  @override
  void dispose() {
    shareCon.server.stop();
    if (Platform.isAndroid) {
      ThanPkgAndroid.getInstance.osHandler.keepScreenOn(false);
    }
    super.dispose();
  }

  final shareCon = ShareController.instance;
  ColorScheme get col => Theme.of(context).colorScheme;

  void init() async {
    try {
      await shareCon.init();
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: col.surface,
      appBar: AppBar(title: Text('Share')),
      body: Center(child: _body),
    );
  }

  Widget get _body {
    if (!shareCon.server.isOpened) {
      return FilledButton(
        onPressed: () async {
          await shareCon.start();
          setState(() {});
        },
        child: Text('Start Server'),
      );
    }
    return Column(
      mainAxisAlignment: .center,
      children: [
        Text(
          'Server Running on http://${shareCon.server.getAddress?.host}:${shareCon.server.port}',
          style: TextStyle(color: Colors.green),
        ),
      ],
    );
  }
}
