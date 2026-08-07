import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart' hide SortButton;
import 'package:than_pkg/than_pkg.dart' hide TPlatform;
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/state/reader_file_sort_controller.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';
import 'package:than_reader/main_app/components/all_tags_component.dart';
import 'package:than_reader/main_app/components/app_sliver_view.dart';
import 'package:than_reader/main_app/components/folder_sliver_view.dart';
import 'package:than_reader/main_app/components/folder_style_chooser.dart';
import 'package:than_reader/main_app/home/app_file_filter.dart';
import 'package:than_reader/main_app/home/pdf_fav_all_screen.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/partials/sort_provider.dart';
import 'package:than_reader/router.dart';

class ReaderFileListPage extends StatefulWidget {
  const ReaderFileListPage({super.key});

  @override
  State<ReaderFileListPage> createState() => _ReaderFileListPageState();
  static final desktopEnable = ValueNotifier<bool>(true);
}

class _ReaderFileListPageState extends State<ReaderFileListPage> {
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
    if (ReaderFileAllStateConroller.instance.state.list.isEmpty) {
      await ReaderFileAllStateConroller.instance.fetchList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Than Reader"),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: ReaderFileAllStateConroller.instance.fetchList,
              icon: Icon(Icons.refresh),
            ),
        ],
      ),
      body: desktopDropWidget,
    );
  }

  Widget get desktopDropWidget {
    return ValueListenableBuilder(
      valueListenable: ReaderFileListPage.desktopEnable,
      builder: (context, value, child) {
        return DropTarget(
          enable: value,
          onDragDone: (details) {
            if (details.files.isEmpty) return;
            final file = details.files.first;
            if (!file.path.endsWith('.pdf')) return;
            goReader(ReaderFile.fromFile(File(file.path)));
          },
          child: _widget,
        );
      },
    );
  }

  Widget get _widget {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller.instance.stream,
      initialData: ReaderFileAllStateConroller.instance.state,
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
              SliverToBoxAdapter(child: AppFileFilterHeader()),
              subHeaderListCheckerWidget,

              AppFileFilter(builder: (context, files) => _listWidget(files)),
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
          stream: ReaderFileSortController.instance.stream,
          builder: (context, snapshot) {
            return SortButton(
              value: ReaderFileAllStateConroller.instance.sortItem,
              list: ReaderFileAllStateConroller.instance.sortList,
              onApply: ReaderFileAllStateConroller.instance.setSort,
            );
          },
        ),
      ],
    );
  }

  Widget get subHeaderListCheckerWidget {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller().stream,
      builder: (context, asyncSnapshot) {
        final tagsLeg = ReaderFileAllStateConroller().allTags.length;
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
  Widget _listWidget(List<ReaderFile> list) {
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
  Widget folderViewWidget(List<ReaderFile> list) {
    final Map<String, List<ReaderFile>> folders = {};
    for (var file in list) {
      folders.putIfAbsent(file.parentPath.onlyName, () => []).add(file);
    }
    return FolderSliverView(folders: folders);
  }

  // pdf item list
  Widget appViewWidget(List<ReaderFile> list) {
    return AppSliverView(list: list);
  }

  void goReader(ReaderFile pdf) async {
    ReaderFileListPage.desktopEnable.value = false;
    await goReaderModuleApp(context, pdf);
    ReaderFileListPage.desktopEnable.value = true;
  }
}
