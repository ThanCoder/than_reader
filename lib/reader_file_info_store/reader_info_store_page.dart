import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/platforms/components/dialog/confirm_alert_dialog.dart';
import 'package:than_reader/reader_file_info_store/models/reader_info.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store_desc_page.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store_form_page.dart';

class ReaderInfoStorePage extends StatefulWidget {
  const new({super.key});

  @override
  State<ReaderInfoStorePage> createState() => _ReaderInfoStorePageState();
}

class _ReaderInfoStorePageState extends State<ReaderInfoStorePage> {
  final store = ReaderInfoStore.instance.store;
  final infoBox = ReaderInfoStore.instance.infoBox;
  ColorScheme get col => Theme.of(context).colorScheme;

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
    final res = await context
        .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
          builder: (mainCtx) => ReaderInfoStoreFormPage(info: info, desc: desc),
        );
    if (res == null) return;
    await infoBox.update(
      info.generatedId,
      value: info,
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
        onPressed: () async {
          final res = await context
              .pushMaterialPageRoute<ReaderInfoStoreFormPageData>(
                builder: (mainCtx) =>
                    ReaderInfoStoreFormPage(info: .empty(), desc: ''),
              );
          if (res == null) return;
          await infoBox.add(
            res.info,
            contentWriter: TextCompressContentWriter(res.desc),
          );
        },
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
          context.pushMaterialPageRoute(
            builder: (mainCtx) => ReaderInfoStoreDescPage(info: info),
          );
        },
        onSecondaryTap: () => showItemMenu(info),
        onLongPress: () => showItemMenu(info),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                spacing: 5,
                children: [
                  Text(
                    info.title,
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(fontWeight: .w600, color: col.onSurface),
                  ),
                  Text(
                    'author: ${info.author}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w400,
                      color: col.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'translator: ${info.translator}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w400,
                      color: col.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Type: ${info.type.label}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w400,
                      color: col.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Date: ${info.date.formatTimeAgo()}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: .w400,
                      color: col.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
