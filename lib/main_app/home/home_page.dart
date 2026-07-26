import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart' hide SortButton;
import 'package:than_pkg/than_pkg.dart' hide TPlatform;
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/models/app_file.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/core/state/pdf_state_conroller.dart';
import 'package:than_reader/main_app/components/all_tags_component.dart';
import 'package:than_reader/main_app/components/app_sliver_view.dart';
import 'package:than_reader/main_app/components/folder_sliver_view.dart';
import 'package:than_reader/main_app/components/folder_style_chooser.dart';
import 'package:than_reader/main_app/home/pdf_fav_all_screen.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_app.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/partials/sort_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  static final desktopEnable = ValueNotifier<bool>(true);
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (!await ThanPkg.platform.isStoragePermissionGranted()) {
      await ThanPkg.platform.requestStoragePermission();
      return;
    }
    await PdfStateConroller.instance.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Than Reader"),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: PdfStateConroller.instance.fetchList,
              icon: Icon(Icons.refresh),
            ),
        ],
      ),
      body: desktopDropWidget,
    );
  }

  Widget get desktopDropWidget {
    return ValueListenableBuilder(
      valueListenable: HomePage.desktopEnable,
      builder: (context, value, child) {
        return DropTarget(
          enable: value,
          onDragDone: (details) {
            if (details.files.isEmpty) return;
            final file = details.files.first;
            if (!file.path.endsWith('.pdf')) return;
            goReader(AppFile.fromFile(File(file.path)));
          },
          child: _widget,
        );
      },
    );
  }

  Widget get _widget {
    return StreamBuilder(
      stream: PdfStateConroller.instance.stream,
      initialData: PdfStateConroller.instance.state,
      builder: (context, snapshot) {
        final state = snapshot.data!;
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        final list = state.list;
        if (list.isEmpty) {
          return Center(
            child: RefreshButton(text: Text('PDF မရှိပါ....'), onClicked: init),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: init,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: headerWidget),
              subHeaderListCheckerWidget,
              _listWidget(list),
            ],
          ),
        );
      },
    );
  }

  Widget get headerWidget {
    return Row(
      children: [
        FolderStyleChooser(),
        favButtonWidget,
        Spacer(),
        ListStyleButton(),
        StreamBuilder(
          stream: PdfStateConroller().stream,
          initialData: PdfStateConroller().state,
          builder: (context, snapshot) {
            final state = snapshot.data!;
            return SortButton(
              value: state.sortItem,
              list: PdfStateConroller().sortList,
              onApply: PdfStateConroller().setSort,
            );
          },
        ),
      ],
    );
  }

  Widget get subHeaderListCheckerWidget {
    return StreamBuilder(
      stream: PdfStateConroller().stream,
      builder: (context, asyncSnapshot) {
        final tagsLeg = PdfStateConroller().allTags.length;
        if (tagsLeg > 0) {
          return SliverToBoxAdapter(
            child: SizedBox(height: 50, width: 200, child: subHeaderWidget),
          );
        }
        return SliverToBoxAdapter();
      },
    );
  }

  Widget get subHeaderWidget {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: .horizontal,
        child: Row(children: [AllTagsComponent()]),
      ),
    );
  }

  Widget get favButtonWidget {
    return StreamBuilder(
      stream: PdfFavController().stateStream,
      builder: (context, asyncSnapshot) {
        if (PdfFavController().state.favPathList.isEmpty) {
          return SizedBox.shrink();
        }
        return InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: () => context.push(builder: (context) => PdfFavAllScreen()),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Text(
                'Favorite',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: .bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget get tagHiddenWidget {
    return Checkbox.adaptive(value: false, onChanged: (value) {});
  }

  //list widget
  Widget _listWidget(List<AppFile> list) {
    return ValueListenableBuilder(
      valueListenable: FolderStyleChooser.valueNotifier,
      builder: (context, value, child) {
        if (value == .groupFolder) {
          return folderViewWidget(list);
        }
        return appViewWidget(list);
      },
    );
  }

  // folder item list
  Widget folderViewWidget(List<AppFile> list) {
    final Map<String, List<AppFile>> folders = {};
    for (var file in list) {
      folders.putIfAbsent(file.parentPath.onlyName, () => []).add(file);
    }
    return FolderSliverView(folders: folders);
  }

  // pdf item list
  Widget appViewWidget(List<AppFile> list) {
    return AppSliverView(list: list);
  }

  void goReader(AppFile pdf) async {
    HomePage.desktopEnable.value = false;
    await AppManager.instance.go<PdfApp, PdfParams, PdfResult>(
      context,
      PdfParams(path: pdf.path, configPath: pdf.configPath),
    );
    HomePage.desktopEnable.value = true;
  }
}
