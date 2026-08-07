import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart' hide SortButton;
import 'package:than_pkg/than_pkg.dart' show ThanPkg;
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';
import 'package:than_reader/core/state/reader_file_sort_controller.dart';
import 'package:than_reader/main_app/home/home_page/home_page_card_list.dart';
import 'package:than_reader/main_app/home/home_page/reader_file_list_page.dart';
import 'package:than_reader/main_app/home/pdf_menu.dart';
import 'package:than_reader/partials/sort_provider.dart';
import 'package:than_reader/router.dart';

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
    await ReaderFileAllStateConroller.instance.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Than Reader'),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: ReaderFileAllStateConroller.instance.fetchList,
              icon: Icon(Icons.refresh),
            ),
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
      ),
      body: bodyWidget,
    );
  }

  Widget get bodyWidget {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller.instance.stream,
      builder: (context, asyncSnapshot) {
        final files = ReaderFileAllStateConroller.instance.state.list;
        if (ReaderFileAllStateConroller.instance.state.isLoading) {
          return Center(child: TLoaderRandom());
        }
        if (files.isEmpty) {
          return Center(
            child: RefreshButton(text: Text('Refresh'), onClicked: init),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: init,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(child: latestAppFilesWidget(files)),
              SliverToBoxAdapter(child: pdfFilesWidget(files)),
              SliverToBoxAdapter(child: epubFilesWidget(files)),
            ],
          ),
        );
      },
    );
  }

  Widget latestAppFilesWidget(List<ReaderFile> files) {
    return HomePageCardList(
      files: files,
      title: Text('Latest Book'),
      onItemClicked: goReader,
      onItemMenuClicked: showPdfMenu,
      onShowAllClicked: () async {
        await context.push(builder: (context) => ReaderFileListPage());
        setState(() {});
      },
    );
  }

  Widget? pdfFilesWidget(List<ReaderFile> files) {
    final pdfs = files.where((e) => e.type == .pdf).toList();
    if (pdfs.isEmpty) return null;
    return HomePageCardList(
      files: pdfs,
      title: Text('PDF Books'),
      onItemClicked: goReader,
      onItemMenuClicked: showPdfMenu,
      onShowAllClicked: () async {
        await context.push(builder: (context) => ReaderFileListPage());
        setState(() {});
      },
    );
  }

  Widget? epubFilesWidget(List<ReaderFile> files) {
    final epubs = files.where((e) => e.type == .epub).toList();
    if (epubs.isEmpty) return null;
    return HomePageCardList(
      files: epubs,
      title: Text('Epub Books'),
      onItemClicked: goReader,
      onItemMenuClicked: showPdfMenu,
      onShowAllClicked: () async {
        await context.push(builder: (context) => ReaderFileListPage());
        setState(() {});
      },
    );
  }

  void goReader(ReaderFile pdf) async {
    // ReaderFileListPage.desktopEnable.value = false;
    await goReaderModuleApp(context, pdf);
    // ReaderFileListPage.desktopEnable.value = true;
    setState(() {});
  }

  void showPdfMenu(ReaderFile pdf) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      builder: (context) => PdfMenu(pdf: pdf, mainContext: context),
    );
  }
}
