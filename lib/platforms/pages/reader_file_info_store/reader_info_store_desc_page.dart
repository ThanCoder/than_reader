import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/controller/all_files/all_file_controller.dart';
import 'package:than_reader/core/controller/i_controller.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/platforms/components/menu/reader_item_menu_sheet.dart';
import 'package:than_reader/platforms/components/reader_list_item.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';
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

  @override
  void initState() {
    super.initState();

    final ids = widget.info.configIds;
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
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Info')),
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
          widget.info.title,
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
            _wrapItem('author: ${widget.info.author}'),
            _wrapItem('translator: ${widget.info.translator}'),
            if (widget.info.mc.isNotEmpty) _wrapItem('MC: ${widget.info.mc}'),
            _wrapItem('Date: ${widget.info.date.formatTimeAgo()}'),
          ],
        ),

        // _wrapperWidget('Config Id', list: widget.info.configIds),
        _wrapperWidget('Genres', list: widget.info.genres),
        _wrapperWidget('Tags', list: widget.info.tags),
        _wrapperWidget(
          'Urls',
          list: widget.info.urls,
          onTap: (item) {
            launchUrlString(item);
          },
        ),
      ],
    );
  }

  Widget get descWidget {
    return FutureBuilder(
      future: widget.info.getContent<String>(),
      builder: (context, snapshot) {
        String desc = '';
        if (snapshot.hasData) {
          final res = snapshot.data!;

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
          style: TextStyle(fontSize: 18),
        );
        // return Column(
        //   children: [SelectableText(desc, style: TextStyle(fontSize: 18))],
        // );
      },
    );
  }

  Widget _wrapItem(String text, {bool isSelectable = true}) {
    final sty = TextStyle(
      fontSize: 14,
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
          return ReaderListItem(
            file: item,
            onClicked: (file) {
              goReaderModuleApp(context, file, canGoInfoPage: false);
            },
            onRightClicked: (file) {
              ReaderItemMenuSheet.show(context, file: file);
            },
          );
        },
      ),
    );
  }
}
