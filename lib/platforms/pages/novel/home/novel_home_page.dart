import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_thumb_item.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/const_keys.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/utils/app_utils.dart';
import 'package:than_reader/ui/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/ui/dialog/error_alert_dialog.dart';
import 'package:than_reader/ui/dialog/prompt_alert_dialog.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_controller.dart';
import 'package:than_reader/platforms/pages/novel/models/novel_file.dart';
import 'package:than_reader/platforms/pages/novel/home/novel_file_item_menu.dart';
import 'package:than_reader/platforms/pages/novel/desc_page/novel_desc_home_page.dart';

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
        title: 'New Novel File',
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

  void _onReanme(NovelFile file) async {
    final txt = await showPromptAlertDialog(
      context,
      file.name,
      title: 'Rename NovelFile',
      closeText: 'Close',
      confirmText: 'Rename',
      onErrorCheck: (text) {
        if (text.isEmpty) {
          return 'Required!';
        }
        if (text == file.name) return null;
        final f = File(
          '${file.path.pathBuf.parent.join(text).path}.${file.ext}',
        );
        if (f.existsSync()) {
          return 'Already Exists';
        }

        return null;
      },
    );
    if (txt == null || txt == file.name) return;
    final newPath = '${file.path.pathBuf.parent.join(txt).path}.${file.ext}';
    await con.rename(file, newPath);
  }

  void _onDelete(NovelFile file) async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete Forever?',
      closeText: 'No',
      confirmText: 'Delete Forever!',
      confirmColor: context.colorScheme.error,
      confirmForegroundColor: context.colorScheme.onError,
    );
    if (!conf) return;
    await con.delete(file);
  }

  void showItemMenu(NovelFile file) {
    NovelFileItemMenu.show(
      context,
      file: file,
      props: .new(
        onRename: () => _onReanme(file),
        onDelete: () => _onDelete(file),
      ),
    );
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'newNovelFile',
        onPressed: newNovelFile,
        child: Icon(Icons.add_outlined),
      ),
      body: _body,
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
              if (con.error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Text(con.error!, style: TextStyle(color: col.error)),
                  ),
                ),

              if (con.error == null && con.list.isEmpty)
                SliverFillRemaining(child: Center(child: Text('Not Found!'))),
              // list
              SliverPadding(
                padding: .symmetric(vertical: 6, horizontal: 8),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: con.list.length,
                  itemBuilder: (context, index) => listItem(con.list[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget listItem(NovelFile file) {
    return GestureDetector(
      onTap: () => context.pushMaterialPageRoute(
        builder: (mainCtx) => NovelDescHomePage(file: file),
      ),
      onSecondaryTap: () => showItemMenu(file),
      onLongPress: () => showItemMenu(file),
      child: Container(
        padding: .symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: .circular(14),
          color: col.surfaceContainer,
        ),
        child: Row(
          spacing: 8,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: .circular(20),
                child: NovelThumbItem(file: file),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 5,
                children: [
                  Text(
                    file.name,
                    maxLines: 2,
                    overflow: .ellipsis,
                    style: TextStyle(fontWeight: .w700, fontSize: 14),
                  ),
                  Row(
                    children: [
                      Text(
                        'Novel Database File',
                        style: TextStyle(fontWeight: .w400, fontSize: 12),
                      ),
                      Spacer(),
                      Text(file.size.fileSizeLabel()),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(file.date.formatDate()),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
