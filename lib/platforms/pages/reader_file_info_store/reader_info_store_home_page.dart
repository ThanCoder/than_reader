import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/ui/build_context_x.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/ui/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/components/reader_cover_file.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_desc_page.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_form_page.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/routes.dart';

class ReaderInfoStoreHomePage extends StatefulWidget {
  const new({super.key, this.bookTitle, this.bookConfigIds});
  final String? bookTitle;
  final String? bookConfigIds;

  @override
  State<ReaderInfoStoreHomePage> createState() =>
      _ReaderInfoStoreHomePageState();
}

class _ReaderInfoStoreHomePageState extends State<ReaderInfoStoreHomePage> {
  final store = ReaderInfoStore.instance.store;
  final infoBox = ReaderInfoStore.instance.infoBox;
  ColorScheme get col => Theme.of(context).colorScheme;
  final searchFoc = FocusNode();
  final searchCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    searchFoc.dispose();
  }

  bool isSearched = false;

  Future<void> init() async {}

  void _onSearch(String val) {
    setState(() {
      isSearched = true;
    });
  }

  void createNewInfo() async {
    final res = await context
        .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
          builder: (mainCtx) => ReaderInfoStoreFormPage(
            info: .empty(
              title: widget.bookTitle,
              configIds: [?widget.bookConfigIds],
            ),
            desc: '',
          ),
        );
    if (res == null) return;
    await infoBox.add(
      res.info,
      contentWriter: TextCompressContentWriter(res.desc),
    );
  }

  void deleteItem(ReaderInfo info) async {
    final conf = await showConfirmDialog(
      context,
      'Want To Delete?',
      confirmText: 'Delete',
      confirmColor: col.error,
      confirmForegroundColor: col.onError,
    );
    if (!conf) return;
    await infoBox.deleteById(info.generatedId);
  }

  void editFormPage(ReaderInfo info) async {
    await editReaderFileFormPage(
      context,
      info: info,
      bookConfigIds: widget.bookConfigIds,
    );

    // String desc = '';
    // final descRes = await info.getContent<String>();
    // if (descRes.isOk) {
    //   desc = descRes.unwrap();
    // }
    // if (!mounted) return;
    // final res = await context
    //     .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
    //       builder: (mainCtx) => ReaderInfoStoreFormPage(
    //         info: info,
    //         desc: desc,
    //         newConfigId: widget.bookConfigIds,
    //       ),
    //     );
    // if (res == null) return;

    // await infoBox.updateByid(
    //   info.generatedId,
    //   value: res.info,
    //   contentWriter: TextCompressContentWriter(res.desc),
    // );
  }

  void onTap(ReaderInfo info) {
    if (widget.bookTitle != null) {
      editFormPage(info);
      return;
    }
    context.pushMaterialPageRoute(
      builder: (mainCtx) => ReaderInfoStoreDescPage(info: info),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reader File Info Store')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 12),
            sliver: SliverList.list(children: [_searchbar()]),
          ),
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 12),
            sliver: _body(),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 70)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewInfo,
        child: Icon(Icons.new_label_outlined),
      ),
    );
  }

  SearchBar _searchbar() => SearchBar(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: .circular(14)),
    ),
    onChanged: _onSearch,
    controller: searchCon,
    hintText: 'Search....',
    focusNode: searchFoc,
    onTapOutside: (event) {
      searchFoc.unfocus();
      searchCon.clear();
      setState(() {
        isSearched = false;
      });
    },
    trailing: [
      IconButton(
        onPressed: () {
          searchFoc.unfocus();
        },
        icon: Icon(Icons.clear_all_outlined),
      ),
    ],
  );

  Widget _body() {
    return StreamBuilder(
      stream: store.events.all,
      builder: (context, asyncSnapshot) {
        return FutureBuilder(
          future: infoBox.getAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            var list = snapshot.data ?? [];
            if (isSearched && searchCon.text.isNotEmpty) {
              list = list
                  .where((e) => e.title.upper.contains(searchCon.text.upper))
                  .toList();
            }
            list.sort((a, b) => b.date.compareTo(a.date));
            return SliverList.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = list[index];
                return _item(item);
              },
            );
          },
        );
      },
    );
  }

  Widget? _cover(ReaderInfo info) {
    if (info.configIds.isNotEmpty) {
      final file =
          ControllerManager.read<AllFileController>().map[info.configIds.first];
      if (file != null) {
        return SizedBox(
          width: 80,
          height: 80,
          child: ReaderCoverFile(file: file),
        );
      }
    }
    return null;
  }

  Widget _item(ReaderInfo info) {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: InkWell(
        borderRadius: .circular(15),
        onTap: () => onTap(info),
        child: Row(
          spacing: 10,
          children: [
            ?_cover(info),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 10,
                children: [
                  Text(
                    info.title,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(fontWeight: .w600, color: col.onSurface),
                  ),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      _wrapItem('author: ${info.author}'),
                      _wrapItem('translator: ${info.translator}'),
                      _wrapItem(info.date.formatDate()),
                      if (info.isAdult) _wrapItem('Adult'),
                      _wrapItem(info.isCompleted ? 'Completed' : 'OnGoing'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            _itemPopupMenu(info),
          ],
        ),
      ),
    );
  }

  Widget _itemPopupMenu(ReaderInfo info) => PopupMenuButton<String>(
    initialValue: 'edit',
    borderRadius: .circular(12),
    onSelected: (value) {
      switch (value) {
        case 'edit':
          editFormPage(info);
          break;
        case 'delete':
          deleteItem(info);
          break;
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'edit',
        child: Row(
          spacing: 10,
          children: [Icon(Icons.edit_document), Text('Edit')],
        ),
      ),
      PopupMenuItem(
        value: 'delete',
        child: Row(
          spacing: 10,
          children: [Icon(Icons.delete_forever_outlined), Text('Delete')],
        ),
      ),
    ],
  );

  Widget _wrapItem(String text) {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: col.secondary,
        borderRadius: .circular(15),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: .w400,
          color: col.onSecondary,
        ),
      ),
    );
  }
}
