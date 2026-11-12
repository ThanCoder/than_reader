import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:material_ui/material_ui.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/utils/reader_file_util.dart';
import 'package:than_reader/platforms/components/dialog/error_alert_dialog.dart';
import 'package:than_reader/platforms/components/menu/reader_item_menu_sheet.dart';
import 'package:than_reader/platforms/components/reader_list_item.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/routes.dart';
import 'package:than_reader/router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReaderInfoStoreDescPage extends StatefulWidget {
  const new({super.key, required this.info});
  final ReaderInfo info;

  @override
  State<ReaderInfoStoreDescPage> createState() =>
      _ReaderInfoStoreDescPageState();
}

class _ReaderInfoStoreDescPageState extends State<ReaderInfoStoreDescPage> {
  List<ReaderFile> list = [];
  late ReaderInfo info;

  @override
  void initState() {
    info = widget.info;

    super.initState();

    final ids = info.configIds;
    if (ids.isNotEmpty) {
      final books = <String, ReaderFile>{};
      for (var f in allCon.list) {
        books[f.configId] = f;
      }
      for (var id in ids) {
        final f = books[id];
        if (f == null) continue;
        list.add(f);
      }
      if (!mounted) return;
      setState(() {});
    }
  }

  final allCon = ControllerManager.read<AllFileController>();
  final infoBox = ReaderInfoStore.instance.infoBox;

  void showMenu() async {
    await editReaderFileFormPage(
      context,
      info: info,
      // bookConfigIds: info.configIds,
    );
    final res = await infoBox.getById(widget.info.generatedId);
    if (!mounted) return;

    if (res.isErr) {
      showErrorDialog(context, res.unwrapError());
      return;
    }
    info = res.unwrap();
    setState(() {});
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        actions: [
          IconButton(onPressed: showMenu, icon: Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [infoWidget, Divider(), descWidget],
                ),
              ),
            ],
          ),
          // book list
          _bookListWidget,
          SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  Widget get infoWidget {
    return Column(
      crossAxisAlignment: .start,
      spacing: 10,
      children: [
        Text(
          info.title,
          maxLines: 1,
          overflow: .ellipsis,
          style: TextStyle(
            fontWeight: .w600,
            color: col.onSurface,
            fontSize: 20,
          ),
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: [
            _wrapItem('author: ${info.author}'),
            _wrapItem('translator: ${info.translator}'),
            if (info.mc.isNotEmpty) _wrapItem('MC: ${info.mc}'),
            _wrapItem('Date: ${info.date.formatTimeAgo()}'),
          ],
        ),

        // _wrapperWidget('Config Id', list: info.configIds),
        _wrapperWidget('Genres', list: info.genres),
        _wrapperWidget('Tags', list: info.tags),
        _wrapperWidget(
          'Urls',
          list: info.urls,
          onTap: (item) {
            launchUrlString(item);
          },
        ),
      ],
    );
  }

  Widget get descWidget {
    return FutureBuilder(
      future: infoBox.getContent<String>(info),
      builder: (context, snapshot) {
        String desc = '';
        if (snapshot.hasData) {
          final res = snapshot.data!;
          if (res.isErr) {
            desc = res.unwrapError();
          }
          if (res.isOk) {
            desc = res.unwrap();
          }
        }
        return ExpandableText(
          desc,
          expandText: 'Show More',
          collapseText: 'Show Less',
          linkColor: Colors.blue,
          maxLines: 9,
          style: TextStyle(fontSize: 16),
        );
        // return Column(
        //   children: [SelectableText(desc, style: TextStyle(fontSize: 18))],
        // );
      },
    );
  }

  Widget _wrapItem(String text, {bool isSelectable = true}) {
    final sty = TextStyle(
      fontSize: 12,
      fontWeight: .w400,
      color: col.onSecondary,
    );
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: col.secondary,
        borderRadius: .circular(15),
      ),
      child: isSelectable
          ? SelectableText(text, style: sty)
          : Text(text, style: sty),
    );
  }

  Widget _wrapperWidget(
    String title, {
    required List<String> list,
    void Function(String item)? onTap,
  }) {
    if (list.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: .w600,
              color: col.onSurface,
            ),
          ),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: list
                .map(
                  (e) => GestureDetector(
                    onTap: () => onTap?.call(e),
                    child: _wrapItem(e, isSelectable: false),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget get _bookListWidget {
    return SliverPadding(
      padding: .symmetric(vertical: 10, horizontal: 15),
      sliver: SliverList.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return FutureBuilder(
            future: ReaderFileUtil.getPdfConfigOrNull(item),
            builder: (context, snapshot) {
              final cf = snapshot.data;

              return Column(
                children: [
                  ReaderListItem(
                    file: item,
                    onClicked: (file) async {
                      await goReaderModuleApp(
                        context,
                        file,
                        canGoInfoPage: false,
                      );
                      if (!mounted) return;
                      setState(() {});
                    },
                    onRightClicked: (file) async {
                      await ReaderItemMenuSheet.show(context, file: file);
                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                  if (cf != null && cf.totalPage > 0)
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          '${cf.page}/${cf.totalPage} - ${((cf.page / cf.totalPage) * 100).toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 14),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: cf.page / cf.totalPage,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
