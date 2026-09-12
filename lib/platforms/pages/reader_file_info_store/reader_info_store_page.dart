import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_desc_page.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/reader_info_store_form_page.dart';

class ReaderInfoStorePage extends StatefulWidget {
  const new({super.key, this.bookTitle, this.bookConfigIds});
  final String? bookTitle;
  final List<String>? bookConfigIds;

  @override
  State<ReaderInfoStorePage> createState() => _ReaderInfoStorePageState();
}

class _ReaderInfoStorePageState extends State<ReaderInfoStorePage> {
  final store = ReaderInfoStore.instance.store;
  final infoBox = ReaderInfoStore.instance.infoBox;
  ColorScheme get col => Theme.of(context).colorScheme;

  void createNewInfo() async {
    final res = await context
        .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
          builder: (mainCtx) => ReaderInfoStoreFormPage(
            info: .empty(
              title: widget.bookTitle,
              configIds: widget.bookConfigIds,
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

  void showItemMenu(ReaderInfo info) async {
    String desc = '';
    final descRes = await info.getContent<String>();
    if (descRes.isOk) {
      desc = descRes.unwrap();
    }
    if (!mounted) return;
    final bookConfigIds = widget.bookConfigIds;
    if (bookConfigIds != null && bookConfigIds.isNotEmpty) {
      for (var id in bookConfigIds) {
        if (info.configIds.any((e) => e != id)) {
          info.configIds.add(id);
        }
      }
    }
    final res = await context
        .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
          builder: (mainCtx) => ReaderInfoStoreFormPage(info: info, desc: desc),
        );
    if (res == null) return;

    await infoBox.update(
      info.generatedId,
      value: res.info,
      contentWriter: TextCompressContentWriter(res.desc),
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
            sliver: _body(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewInfo,
        child: Icon(Icons.new_label_outlined),
      ),
    );
  }

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
            final list = snapshot.data ?? [];
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

  Widget _item(ReaderInfo info) {
    return Container(
      padding: .symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: col.surfaceContainer,
        borderRadius: .circular(15),
      ),
      child: InkWell(
        borderRadius: .circular(15),
        onTap: () {
          if (widget.bookTitle != null) {
            showItemMenu(info);
            return;
          }
          context.pushMaterialPageRoute(
            builder: (mainCtx) => ReaderInfoStoreDescPage(info: info),
          );
        },
        child: Row(
          children: [
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
                      _wrapItem('Type: ${info.type.label}'),
                      _wrapItem('Date: ${info.date.formatTimeAgo()}'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              spacing: 8,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: col.error,
                    foregroundColor: col.onError,
                  ),
                  onPressed: () {
                    deleteItem(info);
                  },
                  icon: Icon(Icons.delete_forever_outlined),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: col.secondaryContainer,
                    foregroundColor: col.onSecondaryContainer,
                  ),
                  onPressed: () {
                    showItemMenu(info);
                  },
                  icon: Icon(Icons.edit_document),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
