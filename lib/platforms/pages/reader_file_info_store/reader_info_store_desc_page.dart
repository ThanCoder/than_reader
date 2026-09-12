import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/platforms/pages/reader_file_info_store/models/reader_info.dart';

class ReaderInfoStoreDescPage extends StatefulWidget {
  const new({super.key, required this.info});
  final ReaderInfo info;

  @override
  State<ReaderInfoStoreDescPage> createState() =>
      _ReaderInfoStoreDescPageState();
}

class _ReaderInfoStoreDescPageState extends State<ReaderInfoStoreDescPage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.info.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [infoWidget, Divider(), descWidget],
          ),
        ),
      ),
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
        return SelectableText(desc, style: TextStyle(fontSize: 18));
      },
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
            _wrapItem('Type: ${widget.info.type.label}'),
            _wrapItem('Date: ${widget.info.date.formatTimeAgo()}'),
          ],
        ),

        _wrapperWidget('Config Id', list: widget.info.configIds),
        _wrapperWidget('Genres', list: widget.info.genres),
        _wrapperWidget('Tags', list: widget.info.tags),
        _wrapperWidget('Urls', list: widget.info.urls),
      ],
    );
  }

  Widget _wrapItem(String text) {
    return Container(
      padding: .symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: col.secondary,
        borderRadius: .circular(15),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: .w400,
          color: col.onSecondary,
        ),
      ),
    );
  }

  Widget _wrapperWidget(String title, {required List<String> list}) {
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
            children: list.map((e) => _wrapItem(e)).toList(),
          ),
        ],
      ),
    );
  }
}
