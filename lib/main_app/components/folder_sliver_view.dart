import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:than_reader/core/context_extensions.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/main_app/components/list_style_button.dart';
import 'package:than_reader/main_app/home/app_result_screen.dart';

class FolderSliverView extends StatefulWidget {
  final Map<String, List<ReaderFile>> folders;
  const FolderSliverView({super.key, required this.folders});

  @override
  State<FolderSliverView> createState() => _FolderSliverViewState();
}

class _FolderSliverViewState extends State<FolderSliverView> {
  @override
  Widget build(BuildContext context) {
    final folderEntries = widget.folders.entries.toList();

    return ValueListenableBuilder(
      valueListenable: ListStyleButton.valueNotifier,
      builder: (context, value, child) {
        if (value == .grid) {
          return SliverGrid.builder(
            itemCount: folderEntries.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 200,
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (context, index) => gridStyle(folderEntries[index]),
          );
        }
        return SliverList.builder(
          itemCount: widget.folders.length,
          itemBuilder: (context, index) => listStyle(folderEntries[index]),
        );
      },
    );
  }

  Widget listStyle(MapEntry<String, List<ReaderFile>> entry) {
    final allSize = entry.value.fold(0, (prev, ele) => prev + ele.size);
    return InkWell(
      onTap: () => goResultPage(entry),
      child: Row(
        children: [
          FittedBox(child: Icon(Icons.folder, size: 90)),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text('T: ${entry.key}'),
              Text('Items: ${entry.value.length}'),
              Text('Size: ${allSize.fileSizeLabel()}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget gridStyle(MapEntry<String, List<ReaderFile>> entry) {
    final allSize = entry.value.fold(0, (prev, ele) => prev + ele.size);
    return InkWell(
      onTap: () => goResultPage(entry),
      child: Column(
        children: [
          FittedBox(child: Icon(Icons.folder, size: 90)),
          Column(
            crossAxisAlignment: .center,
            children: [
              Text('T: ${entry.key}'),
              Text('Items: ${entry.value.length}'),
              Text('Size: ${allSize.fileSizeLabel()}'),
            ],
          ),
        ],
      ),
    );
  }

  void goResultPage(MapEntry<String, List<ReaderFile>> entry) {
    context.push(
      builder: (context) =>
          AppResultScreen(title: entry.key, list: entry.value),
    );
  }
}
