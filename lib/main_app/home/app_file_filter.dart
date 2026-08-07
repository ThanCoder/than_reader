import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_reader/core/models/reader_file.dart';
import 'package:than_reader/core/state/reader_file_all_state_conroller.dart';

class AppFileFilterHeader extends StatelessWidget {
  const AppFileFilterHeader({super.key});

  static final valueNotifier = ValueNotifier('All');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller.instance.stream,
      builder: (context, asyncSnapshot) {
        final files = ReaderFileAllStateConroller.instance.fileTypes;

        return ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            return SingleChildScrollView(
              scrollDirection: .horizontal,
              child: Row(
                spacing: 4,
                children: [
                  item('All'),
                  ...files.map((e) => item(e.name.toCaptalize)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget item(String name) {
    return TChip(
      avatar: name == valueNotifier.value ? Icon(Icons.check) : null,
      title: Text(name),
      onClick: () {
        valueNotifier.value = name;
      },
    );
  }
}

class AppFileFilter extends StatelessWidget {
  final Function(BuildContext context, List<ReaderFile> files) builder;
  const AppFileFilter({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReaderFileAllStateConroller.instance.stream,
      builder: (context, asyncSnapshot) {
        return ValueListenableBuilder(
          valueListenable: AppFileFilterHeader.valueNotifier,
          builder: (context, value, child) {
            final files = ReaderFileAllStateConroller.instance.state.list;
            if (value.toLowerCase() == FileType.pdf.name.toLowerCase()) {
              return builder(
                context,
                files.where((e) => e.type == .pdf).toList(),
              );
            }
            if (value.toLowerCase() == FileType.epub.name.toLowerCase()) {
              return builder(
                context,
                files.where((e) => e.type == .epub).toList(),
              );
            }
            return builder(context, files);
          },
        );
      },
    );
  }
}
