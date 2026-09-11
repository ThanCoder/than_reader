import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store.dart';
import 'package:than_reader/reader_file_info_store/reader_info_store_form_page.dart';

class ReaderInfoStorePage extends StatefulWidget {
  const new({super.key});

  @override
  State<ReaderInfoStorePage> createState() => _ReaderInfoStorePageState();
}

class _ReaderInfoStorePageState extends State<ReaderInfoStorePage> {
  final store = ReaderInfoStore.instance.store;
  final infoBox = ReaderInfoStore.instance.infoBox;

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
                    ReaderInfoStoreFormPage(info: .empty(), des: ''),
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
      stream: store.events.addId,
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

            return SliverList.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Text(item.toMap().toString());
              },
            );
          },
        );
      },
    );
  }
}
