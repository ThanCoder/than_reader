import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/components/dialog/prompt_alert_dialog.dart';
import 'package:than_reader/platforms/pages/novel/novel_controller.dart';
import 'package:than_reader/platforms/pages/novel/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/novel_file_item_menu.dart';
import 'package:than_reader/platforms/pages/novel/novel_page.dart';

class NovelHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<NovelHomePage> createState() => _NovelHomePageState();
}

class _NovelHomePageState extends State<NovelHomePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  final con = ControllerManager.read<NovelController>();

  Future<void> init() async {
    await con.fetchList();
  }

  File toDBFile(String name) {
    return File(
      AppUtil.instance.getPlatfromExternalDownloadPath('$name.$novelExtName'),
    );
  }

  void newNovelFile() async {
    try {
      final name = await showPromptAlertDialog(
        context,
        'Untitled',
        confirmText: 'New Novel',
        onErrorCheck: (text) {
          if (text.isEmpty) {
            return 'name required!';
          }
          final f = toDBFile(text);
          if (f.existsSync()) {
            return 'Change Another Name!';
          }
          return null;
        },
      );
      if (name == null) return;
      if (!mounted) return;

      final db = DualStore();
      await db.open(toDBFile(name).path);
      await db.close();
      init();
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, e.toString());
    }
  }

  void showItemMenu(NovelFile file) {
    NovelFileItemMenu.show(context, file: file);
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novel"),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(onPressed: init, icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: _body,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newNovelFile',
        onPressed: newNovelFile,
        child: Icon(Icons.add_outlined),
      ),
    );
  }

  Widget get _body {
    return RefreshIndicator.adaptive(
      onRefresh: init,
      child: StreamBuilder(
        stream: con.events.whereType<NovelControllerStateChanged>(),
        builder: (context, asyncSnapshot) {
          return CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              if (con.isLoading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              if (con.list.isEmpty)
                SliverFillRemaining(child: Center(child: Text('Not Found!'))),

              SliverList.builder(
                itemCount: con.list.length,
                itemBuilder: (context, index) => listItem(con.list[index]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget listItem(NovelFile file) {
    return GestureDetector(
      onSecondaryTap: () => showItemMenu(file),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: .circular(14)),
        tileColor: col.surfaceContainer,
        leading: Icon(Icons.storage_outlined),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        title: Text(file.name),
        subtitle: Text('Novel Database File'),
        onTap: () {
          context.pushMaterialPageRoute(
            builder: (mainCtx) => NovelPage(file: file),
          );
        },
        onLongPress: () => showItemMenu(file),
      ),
    );
  }
}
