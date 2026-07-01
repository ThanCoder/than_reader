import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart' hide TPlatform;
import 'package:than_reader/core/extensions/context_extensions.dart';
import 'package:than_reader/core/models/pdf_file.dart';
import 'package:than_reader/core/state/pdf_fav_controller.dart';
import 'package:than_reader/core/state/pdf_state_conroller.dart';
import 'package:than_reader/main_app/components/pdf_list_item.dart';
import 'package:than_reader/main_app/home/pdf_fav_all_screen.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/modules_apps/app_manager.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_app.dart';
import 'package:than_reader/modules_apps/pdf_modules/pdf_params.dart';
import 'package:than_reader/partials/sort_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
      body: _widget,
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
              SliverToBoxAdapter(child: subHeaderWidget),
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
        IconButton(onPressed: () {}, icon: Icon(Icons.folder)),
        Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.list_rounded)),
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

  Widget get subHeaderWidget {
    return Row(
      children: [
        StreamBuilder(
          stream: PdfFavController().stateStream,
          builder: (context, asyncSnapshot) {
            if (PdfFavController().state.favPathList.isEmpty) {
              return SizedBox.shrink();
            }
            return TChip(
              title: Text('Favorite'),
              onClick: () =>
                  context.push(builder: (context) => PdfFavAllScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _listWidget(List<PdfFile> list) {
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => Card(child: _listItem(list[index])),
    );
  }

  Widget _listItem(PdfFile pdf) {
    return PdfListItem(
      pdf: pdf,
      onMenuClicked: showPdfMenu,
      onClicked: goReader,
    );
  }

  void goReader(PdfFile pdf) async {
    await AppManager.instance.go<PdfApp, PdfParams, PdfResult>(
      context,
      PdfParams(path: pdf.path),
    );
    setState(() {});
  }

  void showPdfMenu(PdfFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
